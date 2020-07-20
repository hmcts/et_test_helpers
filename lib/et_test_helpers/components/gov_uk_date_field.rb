module EtTestHelpers
  module Components
    # A gov.uk GDS standard date field representation for testing
    class GovUKDateField < ::SitePrism::Section
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
               elsif date.nil?
                 nil
               else
                 expected_value
               end
          raise Capybara::ExpectationNotMet unless dt == value
        end

        def set(date)
          if date.is_a?(String)
            parts = date.split('/')
            inputs[0].set(parts[0])
            inputs[1].set(parts[1])
            inputs[2].set(parts[2])
          elsif date.nil?
            inputs[0].set('')
            inputs[1].set('')
            inputs[2].set('')
          else
            inputs[0].set(date.day)
            inputs[1].set(date.month)
            inputs[2].set(date.year)
          end
        end

        def value
          ymd = inputs[0..2].map(&:value).map(&:to_i).reverse
          Date.new(*ymd)
        rescue ArgumentError
          nil
        end
      end

      delegate [:assert_value, :assert_error_message, :set, :value, :label, :hint, :error, :has_no_error?, :has_no_hint?] => :fieldset
    end
  end
end
