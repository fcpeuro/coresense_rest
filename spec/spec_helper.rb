# frozen_string_literal: true

require "coresense_rest"
require "webmock/rspec"

Dir[File.join(__dir__, "support", "**", "*.rb")].sort.each { |f| require f }

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = :expect }
  config.disable_monkey_patching!
  config.order = :random

  # Integration specs hit the live CREST API. They are excluded from the normal
  # (hermetic, WebMock-stubbed) suite unless explicitly opted into.
  unless ENV["CORESENSE_RUN_INTEGRATION"]
    config.filter_run_excluding(:integration)
  end

  # Write specs mutate the live UAT environment. They require a SECOND opt-in
  # on top of :integration, so a normal integration run stays read-only.
  unless ENV["CORESENSE_RUN_WRITE"]
    config.filter_run_excluding(:write)
  end

  # Hermetic examples: stub everything, inject a fake token. Null out any real
  # CORESENSE_* credentials in the environment so the suite is hermetic
  # regardless of the developer's shell (e.g. a sourced .env).
  config.before do |example|
    next if example.metadata[:integration]

    allow(ENV).to receive(:[]).and_call_original
    %w[CORESENSE_USER_ID CORESENSE_SIGN_KEY CORESENSE_TOKEN].each do |key|
      allow(ENV).to receive(:[]).with(key).and_return(nil)
    end

    CoresenseRest.reset_configuration!
    CoresenseRest.configure do |c|
      c.site  = "https://api-fcpuat.coresense.com"
      c.token = "test-jwt-token"
    end
  end

VCR.configure do |config|
  # In CI, replay committed cassettes only: never record, never touch the
  # network. Locally, record new interactions on demand.
  ci = !ENV['CI'].nil?

  config.cassette_library_dir = 'spec/vcr_cassettes'
  config.default_cassette_options = { record: ci ? :none : :new_episodes }

  config.hook_into :webmock
  config.allow_http_connections_when_no_cassette = !ci
  config.configure_rspec_metadata!

  # Never persist the auth token to cassettes. The client sends it in the
  # X-Auth-Token request header (CoresenseRest::Client.get_token). VCR matches
  # on method + URI by default, so scrubbing the header does not affect playback.
  config.before_record do |interaction|
    interaction.request.headers.delete('X-Auth-Token')
  end
end
