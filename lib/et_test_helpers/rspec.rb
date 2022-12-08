require 'capybara/rspec'
module EtTestHelpers
  module RSpec
    def self.stub_build_blob_to_azure_setup
      previous_value = Rails.application.routes.disable_clear_and_finalize
      Rails.application.routes.disable_clear_and_finalize = true
      Rails.application.routes.draw do
        match "/dummy_endpoint_for_dropzone", to: -> (env) { [200, {}, ['']] }, via: :all
      end
      Rails.application.routes.disable_clear_and_finalize = previous_value

      key = "direct_uploads/#{SecureRandom.uuid}".freeze
      base_url = Capybara.current_session.server.base_url
      WebMock.stub_request(:post, "#{ENV.fetch('ET_API_URL', 'http://api.et.127.0.0.1.nip.io:3100/api/v2')}/build_blob")
        .to_return headers: { 'Content-Type': 'application/json' },
                   body:
                     {
                       "data": {
                         "fields": {
                           "key": key,
                           "permissions": '',
                           "version": '',
                           "expiry": '',
                           "resource": '',
                           "signature": ''
                         },
                         "url": "#{base_url}/dummy_endpoint_for_dropzone",
                         "unsigned_url": 'http://jdshfjkshjkfjhadsfds'
                       },
                       "meta": {
                         "cloud_provider": "azure"
                       },
                       "status": "accepted",
                       "uuid": SecureRandom.uuid
                     }.to_json

    end
    def self.stub_build_blob_to_azure_teardown
      Rails.application.reload_routes!
    end
    def self.stub_create_blob_to_azure_setup
      key = "direct_uploads/#{SecureRandom.uuid}".freeze
      WebMock.stub_request(:post, "#{ENV.fetch('ET_API_URL', 'http://api.et.127.0.0.1.nip.io:3100/api/v2')}/create_blob")
      .to_return do |request|
        env = request.headers.transform_keys { |key| key.underscore.upcase }.merge('rack.input' => StringIO.new(request.body))
        parsed_request = Rack::Multipart.parse_multipart(env)
        {
          headers: { 'Content-Type': 'application/json' },
          body:
            {
              "data": {
                "key": key,
                "content_type": parsed_request.dig('file', :type),
                "filename": parsed_request.dig('file', :filename)
              },
              "meta": {
                "cloud_provider": "azure"
              },
              "status": "accepted",
              "uuid": SecureRandom.uuid
            }.to_json
        }
      end

    end
  end
end
RSpec.configure do |config|
  config.before(with_stubbed_azure_upload: true) do
    EtTestHelpers::RSpec.stub_build_blob_to_azure_setup
    EtTestHelpers::RSpec.stub_create_blob_to_azure_setup
  end

  config.after(with_stubbed_azure_upload: true) do
    EtTestHelpers::RSpec.stub_build_blob_to_azure_teardown
  end
end
