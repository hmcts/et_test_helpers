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
        # @return [Capybara::Node::Element] The input element
        element :input, :govuk_field_input

        # @!method error
        # @return [::SitePrism::Section] The label section - note that all errors have a hidden (1px x 1px prefix containing 'Error:' - this section filters that out)
        section :error, :govuk_field_error do
          def text
            root_element.text.gsub(/Error:\n/, '')
          end
        end

        def set(value)
          raise 'Not yet implemented'
        end
      end
      delegate [:set, :label, :hint, :error, :has_no_error?, :has_no_hint?] => :fieldset
    end
  end
end
