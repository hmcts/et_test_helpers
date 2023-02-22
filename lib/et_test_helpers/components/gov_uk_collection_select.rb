require_relative './component_base'
module EtTestHelpers
  module Components
    # A gov.uk GDS standard text field representation for testing
    class GovUKCollectionSelect < ComponentBase
      # @!method label
      # @return [Capybara::Node::Element] The label element
      element :label, :govuk_field_label

      # @!method hint
      # @return [Capybara::Node::Element] The hint element
      element :hint, :govuk_field_hint

      # @!method input
      # @return [Capybara::Node::Element] The select element
      element :input, :govuk_field_select

      # @!method error
      # @return [::SitePrism::Section] The label section - note that all errors have a hidden (1px x 1px prefix containing 'Error:' - this section filters that out)
      section :error, :govuk_field_error do
        def text
          root_element.text.gsub(/Error:\n/, '')
        end
      end

      def assert_error_message(error)
        find(:govuk_field_error, text: error)
      end

      def assert_value(value)
        input selected: value
      end

      def assert_option(value)
        input.assert_selector(:option, value)
      end

      def has_option?(value)
        assert_option(value)
        true
      rescue Capybara::ExpectationNotMet
        false
      end

      def assert_valid_options
        unless root_scope[:options].is_a?(Hash)
          raise "The root scope (#{govuk_component_args.second}) must have an options object for assert_valid_options to work"
        end

        missing = []
        root_scope[:options].values.each do |option|
          option_value = find_option_value(option)
          next if has_option?(option_value)

          missing << "#{::EtTestHelpers.normalize_locator(option)} (:#{option})"
        end
        return if missing.empty?

        raise Capybara::ExpectationNotMet,
              "#{inspect} Expected valid options, but the following are missing :- #{missing}"
      end

      def set(value)
        value = find_option_value(value)
        input.find(:xpath, XPath.generate { |x| x.child(:option)[x.string.n.equals(value)] }).select_option
      end

      def value
        system_value = input[:value]
        return nil if system_value.nil?

        input.find(:xpath, XPath.generate { |x| x.child(:option)[x.attr(:value).equals(system_value)] }).text
      end

      delegate [:disabled?] => :input

      private

      def find_option_value(value)
        return value unless value.is_a?(Symbol)

        translated = t(:"#{govuk_component_args.second}.options.#{value}", raise: false)
        translated ||= t(value)
        translated
      end
    end
  end
end
