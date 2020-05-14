require 'active_support/concern'
require_relative './components'
module EtTestHelpers
  module Page
    extend ActiveSupport::Concern

    class_methods do
      def govuk_component(type)
        klass = "::EtTestHelpers::Components::#{type.to_s.camelize}".safe_constantize
        return klass unless klass.nil?

        raise "Unknown govuk_component with a type of '#{type}'"
      end
    end
  end
end
