require_relative './component_base'
module EtTestHelpers
  module Components
    # A gov.uk GDS standard text area representation for testing
    class GovUKTextArea < ComponentBase
      # @!method label
      # @return [Capybara::Node::Element] The label element
      element :label, :govuk_field_label

      # @!method hint
      # @return [Capybara::Node::Element] The hint element
      element :hint, :govuk_field_hint

      # @!method input
      # @return [Capybara::Node::Element] The input element
      element :input, :fillable_field, type: 'textarea'

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
        input with: value
      end

      def assert_too_many_characters(message = nil)
        if message
          character_count_message(text: message).present?
        else
          character_count_message.present?
        end
      end

      def assert_valid_hint
        unless root_scope.key?(:hint)
          raise "The root scope :'#{parent.govuk_component_args.second}' must have a 'hint' property"
        end

        hint_text = EtTestHelpers.normalize_locator(root_scope[:hint])
        return if has_hint? text: hint_text

        raise Capybara::ExpectationNotMet,
              "#{inspect} Expected valid hint, but there wasn't one with the text '#{EtTestHelpers.normalize_locator(root_scope[:hint])}' (:'#{root_scope[:hint]}')"
      end

      delegate %i[set value disabled?] => :input

      element :character_count_message, '.govuk-character-count__message.govuk-error-message'
    end
  end
end
