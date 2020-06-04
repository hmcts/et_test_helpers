module EtTestHelpers
  module Components
    # A gov.uk GDS standard fieldset representation for testing
    class GovUKFieldset < ::SitePrism::Section
      # @!method label
      # @return [Capybara::Node::Element] The label element
      element :label, 'legend'
    end
  end
end
