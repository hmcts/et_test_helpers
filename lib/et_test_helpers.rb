require "et_test_helpers/version"
require "active_support/core_ext/string"
require "rspec/matchers"
require "et_test_helpers/capybara"
require "et_test_helpers/components"
require "et_test_helpers/page"
require "et_test_helpers/section"
require "et_test_helpers/config"
module EtTestHelpers
  def self.normalize_locator(locator)
    return locator unless locator.is_a?(Symbol)

    translation.call(locator)
  end

  def self.config
    Config.instance
  end

  def self.translation
    config.translation
  end


end
