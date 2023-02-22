require_relative './component_base'
module EtTestHelpers
  module Components
    # A gov.uk GDS standard date field representation for testing
    class GovUKDateField < ComponentBase
      section :fieldset, 'fieldset' do
        # @!method label
        # @return [Capybara::Node::Element] The label element
        element :label, 'fieldset > legend'

        # @!method hint
        # @return [Capybara::Node::Element] The hint element
        element :hint, :govuk_field_hint

        # @!method input
        # @return [Capybara::Node::Element] The input element
        elements :inputs, :govuk_field_input

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
          dt = if expected_value.is_a?(String)
                 Date.parse(expected_value)
               elsif expected_value.nil?
                 nil
               else
                 expected_value
               end
          raise Capybara::ExpectationNotMet unless dt == value
        end

        def set(date)
          if date.is_a?(String)
            parts = date.split('/')
            inputs.each_with_index do |input, idx|
              input.set(parts[idx])
            end
          elsif date.nil?
            inputs.each do |input|
              input.set('')
            end
          elsif inputs.length == 3
            inputs[0].set(date.day)
            inputs[1].set(date.month)
            inputs[2].set(date.year)
          elsif inputs.length == 2
            inputs[0].set(date.month)
            inputs[1].set(date.year)
          else
            raise "A GDS date field must consist of 2 or 3 input elements but this had #{inputs.length}"
          end
        end

        def value
          ymd = inputs[0..2].map(&:value).map(&:to_i).reverse
          Date.new(*ymd)
        rescue ArgumentError
          nil
        end

        def disabled?
          inputs.all?(&:disabled?)
        end

        def valid?
          inputs.length >= 2
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
      end

      delegate %i[assert_value assert_error_message set value label hint error has_no_error? has_no_hint? disabled?
                  has_hint? has_error? valid?] => :fieldset
    end
  end
end
