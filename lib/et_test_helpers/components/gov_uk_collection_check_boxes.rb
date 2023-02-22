require_relative './component_base'
module EtTestHelpers
  module Components
    # A gov.uk GDS standard text field representation for testing
    class GovUKCollectionCheckBoxes < ComponentBase
      section :fieldset, 'fieldset' do
        include EtTestHelpers::Section
        # @!method label
        # @return [Capybara::Node::Element] The label element
        element :label, 'legend'

        # @!method hint
        # @return [Capybara::Node::Element] The hint element
        element :hint, :govuk_field_hint

        # @!method input
        # @return [GovUKCheckbox] The checkbox elements
        sections :checkboxes, GovUKCheckbox, '.govuk-checkboxes__item'

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
          # @TODO We should do this in a way for the values to be correct - this is not ideal
          raise Capybara::ExpectationNotMet unless value.sort == expected_value.sort
        end

        def set(values)
          return if values.nil?

          values = Array(values).map do |v|
            next v unless v.is_a?(Symbol)

            translated = t(:"#{parent.govuk_component_args.second}.options.#{v}", raise: false)
            translated ||= t(v)
            translated
          end
          checkboxes.each do |checkbox|
            checkbox.set(values.include?(checkbox.label.text))
          end
        end

        def value
          checkboxes.select(&:checked?).map(&:label).map(&:text)
        end

        def assert_option(value)
          root_element.assert_selector(:govuk_checkbox, value)
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
          return if missing.empty?

          raise Capybara::ExpectationNotMet,
                "#{inspect} Expected valid options, but the following are missing :- #{missing}"
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

        private

        def checkbox(value)
          GovUKCheckbox.new self, find(:govuk_checkbox, value)
        end

        def root_scope
          parent.i18n_scope.tap do |value|
            unless value.is_a?(Hash) && value[:options].is_a?(Hash)
              raise "#{parent.govuk_component_args.second} must have :options defined in the i18n file"
            end
          end
        end
      end
      delegate %i[assert_value assert_error_message set value label hint error has_no_error? has_no_hint? has_error?
                  has_hint? assert_option has_option? assert_valid_options assert_valid_hint] => :fieldset
    end
  end
end
