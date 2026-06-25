# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../lib/coresense_rest'
require 'vcr'
require 'webmock/rspec'

RSpec.configure do |config|
  config.color = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # Use the specified formatter
  config.formatter = :documentation # :progress, :html,

  config.backtrace_exclusion_patterns << /gems/
  config.backtrace_exclusion_patterns << /<main>/

  config.mock_with :rspec

  config.example_status_persistence_file_path = 'spec/results.txt'
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr_cassettes'
  config.default_cassette_options = { record: :new_episodes }

  config.hook_into :webmock
  config.allow_http_connections_when_no_cassette = true
  config.configure_rspec_metadata!

  # Never persist the auth token to cassettes. The client sends it in the
  # X-Auth-Token request header (CoresenseRest::Client.get_token). VCR matches
  # on method + URI by default, so scrubbing the header does not affect playback.
  config.before_record do |interaction|
    interaction.request.headers.delete('X-Auth-Token')
  end
end
