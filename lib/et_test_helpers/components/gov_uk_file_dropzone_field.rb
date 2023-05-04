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

      element :choose_file_button, 'button[data-gds-dropzone-upload-button]'

      element :filename_hidden_input, 'input[data-submit-key="filename"]', visible: false

      element :remove_element, '*[data-dz-remove]'

      element :input, :field, type: :file, visible: false, disabled: true

      element :filename, 'span[data-dz-name]'

      element :upload_error_message, 'span[data-dz-errormessage]'

      # @!method error
      # @return [::SitePrism::Section] The label section - note that all errors have a hidden (1px x 1px prefix containing 'Error:' - this section filters that out)
      section :error, :govuk_field_error do
        def text
          root_element.text.gsub(/Error:\n/, '')
        end
      end

      def assert_error_message(error)
        find(:govuk_field_error, text: error)
        true
      end

      def assert_upload_error_message(error)
        upload_error_message text: error
        true
      end

      def assert_value(value)
        filename(text: File.basename(value))
        true
      end

      def set(value)
        attach_file(value) do
          choose_file_button.click
        end
        find('.dz-preview.dz-complete')
      end

      def remove_file
        return if filename_hidden_input.value.empty?

        remove_element.click
      end

      # @TODO migrate these
      delegate %i[value disabled?] => :input
    end
  end
end
