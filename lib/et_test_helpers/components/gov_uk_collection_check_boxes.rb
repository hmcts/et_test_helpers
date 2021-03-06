module EtTestHelpers
  module Components
    # A gov.uk GDS standard text field representation for testing
    class GovUKCollectionCheckBoxes < ::SitePrism::Section
      section :fieldset, 'fieldset' do
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

          values = Array(values).map { |v| EtTestHelpers.normalize_locator(v) }
          checkboxes.each do |checkbox|
            checkbox.set(values.include?(checkbox.label.text))
          end
        end

        def value
          checkboxes.select(&:checked?).map(&:label).map(&:text)
        end

        private

        def checkbox(value)
          GovUKCheckbox.new self, find(:govuk_checkbox, value)
        end
      end
      delegate %i[assert_value assert_error_message set value label hint error has_no_error? has_no_hint? has_error? has_hint?] => :fieldset
    end
  end
end
