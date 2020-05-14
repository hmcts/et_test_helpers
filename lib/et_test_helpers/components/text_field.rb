module EtTestHelpers
  module Components
    class TextField < ::SitePrism::Section
      element :label, :govuk_field_label
      element :hint, :govuk_field_hint
      element :input, :govuk_field_input
      section :error, :govuk_field_error do
        def text
          root_element.text.gsub(/Error:\n/, '')
        end
      end
    end
  end
end
