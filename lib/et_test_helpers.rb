require "et_test_helpers/version"
require "active_support/core_ext/string"
require "rspec/matchers"
require "et_test_helpers/capybara"
require "et_test_helpers/components"
require "et_test_helpers/page"
require "et_test_helpers/section"
require "et_test_helpers/config"
require "et_test_helpers/rspec"
module EtTestHelpers
  def self.normalize_locator(locator, translation_options: {})
    return locator unless locator.is_a?(Symbol)

    translation.call(locator, **translation_options)
  end

  def self.config
    Config.instance
  end

  def self.translation
    config.translation
  end

  def self.stub_validate_additional_claimants_api(errors: [])
    # command will be ValidateClaimantsFile
    # data will be {filename: 'file.csv', data_from_key: 'direct_uploads/<uuid>'}
    payload = {
      "meta": {
        "line_count": 10
      },
      "status": errors.empty? ? "accepted" : "not_accepted",
      "uuid": SecureRandom.uuid
    }
    unless errors.empty?
      payload[:errors] = errors.map do |error_spec|
        source_prefix = error_spec[:row].nil? ? "/data_from_key" : "/data_from_key/#{error_spec[:row] - 1}"
        source_attribute = error_spec[:attribute].nil? ? '' : "/#{error_spec[:attribute]}"
        { "status": 422,
          "code": error_spec[:code],
          "title": error_spec[:message] || 'default message',
          "detail": error_spec[:message] || 'default message',
          "source": "#{source_prefix}#{source_attribute}",
          "command": "ValidateClaimantsFile",
          "uuid": SecureRandom.uuid
        }
      end
    end

    WebMock.stub_request(:post, "#{ENV.fetch('ET_API_URL', 'http://api.et.127.0.0.1.nip.io:3100/api/v2')}/validate")
    .to_return headers: { 'Content-Type': 'application/json' },
               status: errors.empty? ? 200 : 422,
               body:
                 payload.to_json

  end
end
