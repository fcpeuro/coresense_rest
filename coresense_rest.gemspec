# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = 'coresense_rest'
  spec.version = '0.0.2'
  spec.authors = [
    'wildbillcat'
  ]
  spec.email = 'pat.mcmorran@fcpeuro.com '
  spec.summary = 'Coresense REST client library in Ruby'
  spec.description = 'A ruby implementation of the CREST client api.'
  spec.homepage = 'https://github.com/fcpeuro/coresense_rest.rb'
  spec.license = 'MIT'

  spec.files = `git ls-files -z`.split("\x0")
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = 'lib'

  spec.add_runtime_dependency 'httparty'
  spec.add_runtime_dependency 'jwt'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
end
