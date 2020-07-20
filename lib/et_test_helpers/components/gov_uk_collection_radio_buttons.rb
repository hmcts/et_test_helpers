module EtTestHelpers
  module Components
    # A gov.uk GDS standard text field representation for testing
    class GovUKCollectionRadioButtons < ::SitePrism::Section
      section :fieldset, 'fieldset' do
        # @!method label
        # @return [Capybara::Node::Element] The label element
        element :label, 'legend'

        # @!method hint
        # @return [Capybara::Node::Element] The hint element
        element :hint, :govuk_field_hint

        # @!method input
        # @return [Capybara::Node::Element] The input element
        element :input, :govuk_field_input

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

        def assert_value(expected_value)
          raise Capybara::ExpectationNotMet unless expected_value == value
        end

        def set(value)
          return if value.nil? # We cannot unset radio buttons so nil has no meaning apart from do nothing
          option(value).select
        end

        def value
          input_id = find(:radio_button, checked:true)[:id]
          find("label[for=#{input_id}").text
        end

        private

        def option(value)
          Option.new self, find(:govuk_radio_button, value)
        end

      end
      delegate [:assert_value, :assert_error_message, :set, :value, :label, :hint, :error, :has_no_error?, :has_no_hint?] => :fieldset

      class Option < ::SitePrism::Section
        def select
          label.click
        end

        private

        element :label, :css, 'label'
        element :input, :css, 'input', visible: false
      end
    end
  end
end
