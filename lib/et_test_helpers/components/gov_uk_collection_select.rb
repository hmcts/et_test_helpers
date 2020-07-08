module EtTestHelpers
  module Components
    # A gov.uk GDS standard text field representation for testing
    class GovUKCollectionSelect < ::SitePrism::Section
      # @!method label
      # @return [Capybara::Node::Element] The label element
      element :label, :govuk_field_label

      # @!method hint
      # @return [Capybara::Node::Element] The hint element
      element :hint, :govuk_field_hint

      # @!method input
      # @return [Capybara::Node::Element] The select element
      element :input, :govuk_field_select

      # @!method error
      # @return [::SitePrism::Section] The label section - note that all errors have a hidden (1px x 1px prefix containing 'Error:' - this section filters that out)
      section :error, :govuk_field_error do
        def text
          root_element.text.gsub(/Error:\n/, '')
        end
      end

      def set(value)
        value = EtTestHelpers.normalize_locator(value)
        input.find(:xpath, XPath.generate {|x| x.child(:option)[x.string.n.equals(value)]}).select_option
      end
    end
  end
end
