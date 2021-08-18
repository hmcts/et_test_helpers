require_relative './component_base'
module EtTestHelpers
  module Components
    # A gov.uk GDS standard text field representation for testing
    class GovUKCollectionRadioButtons < ComponentBase
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
          input_id = find(:radio_button, checked: true, visible: false, wait: 0.5)[:id]
          find("label[for=#{input_id}").text
        rescue Capybara::ElementNotFound
          nil
        end

        def assert_option(value)
          root_element.assert_selector(:govuk_radio_button, value)
        end

        def has_option?(value)
          assert_option(value)
          true
        rescue Capybara::ExpectationNotMet
          false
        end

        def assert_valid_options
          missing = []
          root_scope[:options].values.each do |option|
            next if has_option?(option)

            missing << "#{::EtTestHelpers.normalize_locator(option)} (:#{option})"
          end
          unless missing.empty?
            raise Capybara::ExpectationNotMet,
                  "#{inspect} Expected valid options, but the following are missing :- #{missing}"
          end
        end

        def assert_valid_hint
          raise "The root scope :'#{parent.govuk_component_args.second}' must have a 'hint' property" unless root_scope.key?(:hint)

          hint_text = EtTestHelpers.normalize_locator(root_scope[:hint])
          return if has_hint? text: hint_text

          raise Capybara::ExpectationNotMet,
            "#{inspect} Expected valid hint, but there wasn't one with the text '#{EtTestHelpers.normalize_locator(root_scope[:hint])}' (:'#{root_scope[:hint]}')"
        end

        private

        def option(value)
          Option.new self, find(:govuk_radio_button, value)
        end

        def root_scope
          parent.i18n_scope.tap do |value|
            unless value.is_a?(Hash) && value[:options].is_a?(Hash)
              raise "#{parent.govuk_component_args.second} must have :options defined in the i18n file"
            end
          end
        end
      end
      delegate %i[assert_value assert_error_message set value label hint error has_no_error? has_no_hint? has_hint?
                  has_error? assert_option has_option? assert_valid_options assert_valid_hint] => :fieldset

      class Option < ::SitePrism::Section
        def select
          label.click
        end

        element :label, :css, 'label'
        element :input, :css, 'input', visible: false
      end
    end
  end
end
