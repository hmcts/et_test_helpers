module EtTestHelpers
  module Components
    # A gov.uk GDS standard submit button representation for testing
    class GovUKSubmit < ::SitePrism::Section
      def submit
        root_element.click
      end

      alias :click :submit
      delegate %i[disabled?] => :root_element
    end
  end
end
