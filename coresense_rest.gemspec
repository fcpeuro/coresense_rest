# frozen_string_literal: true

require_relative "lib/coresense_rest/version"

Gem::Specification.new do |spec|
  spec.name        = "coresense_rest"
  spec.version     = CoresenseRest::VERSION
  spec.authors     = ["FCP Euro"]
  spec.email       = ["wildbillcat"]

  spec.summary     = "ActiveResource client for the CoreSense CREST API."
  spec.description = "Ruby client for the CoreSense (CREST) REST API. Provides " \
                     "ActiveResource models under the CoresenseRest namespace " \
                     "with JWT auth and singular, extension-less resource paths."
  spec.homepage    = "https://api-fcpuat.coresense.com/"
  spec.license     = "MIT"

  spec.required_ruby_version = '>= 3.3'

  spec.files = Dir.glob("lib/**/*.rb") + %w[README.md]
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activeresource", ">= 6.0", "< 7.0"

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.12"
  spec.add_development_dependency "webmock", "~> 3.19"
end
