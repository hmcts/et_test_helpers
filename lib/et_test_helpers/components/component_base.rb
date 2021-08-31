require_relative '../section'
module EtTestHelpers
  module Components
    # Base class for all components.
    #  An enhanced version of a site prism section
    class ComponentBase < ::SitePrism::Section
      include ::EtTestHelpers::Section

      def assert_valid_hint
        unless root_scope.key?(:hint)
          raise "The root scope :'#{govuk_component_args.second}' must have a 'hint' property"
        end

        hint_text = EtTestHelpers.normalize_locator(root_scope[:hint])
        return true if has_hint? text: hint_text

        raise Capybara::ExpectationNotMet,
              "#{inspect} Expected valid hint, but there wasn't one with the text '#{EtTestHelpers.normalize_locator(root_scope[:hint])}' (:'#{root_scope[:hint]}')"
      end

      def assert_valid_error(error_locator)
        unless root_scope.key?(:errors)
          raise "The root scope :'#{govuk_component_args.second}' must have an 'errors' object"
        end

        error_text = if error_locator.is_a?(Symbol)
                       EtTestHelpers.normalize_locator(root_scope.dig(:errors, error_locator))
                     else
                       error_locator
                     end
        return true if has_error? text: "Error: #{error_text}"

        raise Capybara::ExpectationNotMet,
              "#{inspect} Expected valid error, but there wasn't one with the text '#{error_text}' (:#{error_locator})"
      end
    end
  end
end
