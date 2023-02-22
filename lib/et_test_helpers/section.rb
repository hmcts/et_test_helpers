require 'active_support/concern'
require_relative './common'
require_relative './components'
module EtTestHelpers
  # A module to use inside a SitePrism::Section to assist with using this gem
  module Section
    extend ActiveSupport::Concern

    included do |_args|
      include Common
    end

    class_methods do
    end
  end
end
