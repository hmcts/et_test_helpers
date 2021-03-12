module EtTestHelpers
  module Components
    # A gov.uk GDS standard text area representation for testing
    class GovUKTextArea < ::SitePrism::Section
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

      def set(value)
        input.set(value)
      end

      def value
        input.value
      end

      def assert_too_many_characters(message = nil)
        if message
          character_count_message(text: message).present?
        else
          character_count_message.present?
        end
      end

      private

      element :character_count_message, '.govuk-character-count__message.govuk-error-message'
    end
  end
end
