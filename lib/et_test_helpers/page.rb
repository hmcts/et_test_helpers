require 'active_support/concern'
require_relative './common'
require_relative './components'
module EtTestHelpers
  # A module to use inside a SitePrism::Page to assist with using this gem
  module Page
    extend ActiveSupport::Concern

    included do
      include Common
    end

    class_methods do
    end
  end
end
