# frozen_string_literal: true

require "spec_helper"

RSpec.describe CoresenseRest::Token do
  let(:user_id)  { "user-123" }
  let(:sign_key) { "super-secret-sign-key" }

  def b64url_decode(str)
    Base64.urlsafe_decode64(str + "=" * ((4 - str.length % 4) % 4))
  end

  describe ".generate" do
    subject(:token) do
      described_class.generate(user_id: user_id, sign_key: sign_key, ttl: 3600, now: 1_000_000)
    end

    it "produces a three-segment JWT" do
      expect(token.split(".").size).to eq(3)
    end

    it "encodes the documented header" do
      header = JSON.parse(b64url_decode(token.split(".").first))
      expect(header).to eq("alg" => "HS256")
    end

    it "sets sub and exp claims (exp = now + ttl)" do
      payload = JSON.parse(b64url_decode(token.split(".")[1]))
      expect(payload["sub"]).to eq(user_id)
      expect(payload["exp"]).to eq(1_000_000 + 3600)
    end

    it "produces a signature that verifies with the sign key (HS256)" do
      signing_input, signature_b64 = token.rpartition(".").values_at(0, 2)
      expected = OpenSSL::HMAC.digest("SHA256", sign_key, signing_input)
      expect(b64url_decode(signature_b64)).to eq(expected)
    end

    it "is base64url (no '+', '/', or padding)" do
      expect(token).not_to match(%r{[+/=]})
    end

    it "honors HS384 / HS512" do
      t = described_class.generate(user_id: user_id, sign_key: sign_key, algorithm: "HS512", now: 0)
      header = JSON.parse(b64url_decode(t.split(".").first))
      expect(header["alg"]).to eq("HS512")
      input, sig = t.rpartition(".").values_at(0, 2)
      expect(b64url_decode(sig)).to eq(OpenSSL::HMAC.digest("SHA512", sign_key, input))
    end

    it "rejects unsupported algorithms" do
      expect { described_class.generate(user_id: user_id, sign_key: sign_key, algorithm: "none") }
        .to raise_error(ArgumentError, /unsupported algorithm/)
    end

    it "requires user_id and sign_key" do
      expect { described_class.generate(user_id: "", sign_key: sign_key) }.to raise_error(ArgumentError)
      expect { described_class.generate(user_id: user_id, sign_key: nil) }.to raise_error(ArgumentError)
    end
  end
end
