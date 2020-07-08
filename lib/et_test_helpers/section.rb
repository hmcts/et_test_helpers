require 'active_support/concern'
require_relative './components'
module EtTestHelpers
  # A module to use inside a SitePrism::Section to assist with using this gem
  module Section
    extend ActiveSupport::Concern

    class_methods do

      # Helper to provide the correct component class for use as the second parameter to the section method in site prism
      # @param [String,Symbol] type - The type of component eg :text_field
      # @return [::EtTestHelpers::Components::GovUKTextField] - This can be many types
      def govuk_component(type)
        klass_name = "::EtTestHelpers::Components::GovUK#{type.to_s.camelize}"
        klass = klass_name.safe_constantize
        return klass unless klass.nil?

        raise "Unknown govuk_component with a type of '#{type}' - it should be defined as '#{klass_name}'"
      end
    end
  end
end
