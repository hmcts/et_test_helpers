require_relative '../section'
module EtTestHelpers
  module Components
    # Base class for all components.
    #  An enhanced version of a site prism section
    class ComponentBase < ::SitePrism::Section
      include ::EtTestHelpers::Section

      def i18n_scope
        t(govuk_component_args.second)
      end

      def t(*args)
        EtTestHelpers::Config.instance.translation.call(*args)
      end
    end
  end
end