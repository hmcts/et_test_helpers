module EtTestHelpers
  module Components
    # A gov.uk GDS dropzone file field representation for testing
    class GovUKFileDropzoneField < ::SitePrism::Section
      # @!method label
      # @return [Capybara::Node::Element] The label element
      element :label, :govuk_field_label

      # @!method hint
      # @return [Capybara::Node::Element] The hint element
      element :hint, :govuk_field_hint

      element :button, :govuk_button

      element :filename_hidden_input, 'input[data-submit-key="filename"]', visible: false

      element :remove_element, '*[data-dz-remove]'

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
        attach_file(value) do
          button.click
        end
        find('.dz-preview.dz-complete')
      end

      def remove_file
        return if filename_hidden_input.value.empty?
        remove_element.click
      end

      # @TODO migrate these
      delegate [:value, :disabled?] => :input
    end
  end
end
