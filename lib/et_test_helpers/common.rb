module EtTestHelpers
  # @private
  module Common
    extend ActiveSupport::Concern

    def t(*args, **kw_args)
      EtTestHelpers::Config.instance.translation.call(*args, **kw_args)
    end

    class_methods do
      # Helper to provide the correct component class for use as the second parameter to the section method in site prism
      # @param [String,Symbol] type - The type of component eg :text_field
      # @return [::EtTestHelpers::Components::GovUKTextField] - This can be many types
      def govuk_component(type, scope: nil)
        component_classname = "GovUK#{type.to_s.camelize}"
        klass_name = "::EtTestHelpers::Components::#{component_classname}"
        klass      = klass_name.safe_constantize
        raise "Unknown govuk_component with a type of '#{type}' - it should be defined as '#{klass_name}'" if klass.nil?

        if scope.nil?
          klass
        else
          wrapper_classname = "#{component_classname}Wrapper#{(Time.now.to_f * 1_000_000).to_i}"
          class_eval <<-CODE, __FILE__, __LINE__ + 1
            class ::EtTestHelpers::Components::#{wrapper_classname} < #{klass_name}
              cattr_accessor :govuk_component_args
              self.govuk_component_args = ['#{type}', :'#{scope}']

              def inspect
                "govuk_component('#{type}', :'#{scope}'}) #{klass_name} \#{super}"
              end

              def i18n_scope
                t(govuk_component_args.second)
              end

              def root_scope
                i18n_scope.tap do |value|
                  unless value.is_a?(Hash)
                    raise "#{scope} must contain at least label in the i18n file"
                  end
                end
              end
            end
          CODE
          ::EtTestHelpers::Components.const_get(wrapper_classname)
        end
      end

      # Defines a section for a gds text input whose specification matches that of the section of
      # the I18n file pointed to by specification.
      # The only specification keys used are
      # - label - The visual label for the text input - which should be a label attached to the field in html
      # - hint - If specified, the text field should have a hint matching this text to be valid
      # - errors - An object containing the different errors that can be shown - matched using has_error?
      DEFAULT_FIND_OPTIONS = {}

      def gds_text_input(name, specification, **kw_args, &block)
        section name,
                govuk_component(:text_field, scope: specification),
                :govuk_text_field,
                specification,
                **DEFAULT_FIND_OPTIONS.merge(kw_args),
                &block
      end

      # Defines a section for a gds fieldset whose specification matches that of the section of
      # the I18n file pointed to by specification.
      # The only specification keys used are
      #  - label - The visual label for the fieldset - which should be a legend in the html
      def gds_fieldset(name, specification, **kw_args, &block)
        section name,
                govuk_component(:fieldset),
                :govuk_fieldset,
                specification,
                **DEFAULT_FIND_OPTIONS.merge(kw_args),
                &block
      end

      # Defines a section for a gds submit button whose specification matches that of the section of
      # the I18n file pointed to by specification.
      # The only specification keys used are
      #  - label - The visual label for the submit button
      def gds_submit_button(name, specification, **kw_args, &block)
        section name,
                govuk_component(:submit),
                :govuk_submit,
                specification,
                **DEFAULT_FIND_OPTIONS.merge(kw_args),
                &block
      end

      # See https://design-system.service.gov.uk/components/error-summary/
      # Defines a section for a gds error summary whose specification matches that of the section of
      # the I18n file pointed to by specification.
      # The only specification keys used are
      #  - label - The visual label for the error summary (i.e. the title in the box)
      def gds_error_summary(name, specification, **kw_args, &block)
        section name,
                govuk_component(:error_summary),
                :govuk_error_summary,
                specification,
                **DEFAULT_FIND_OPTIONS.merge(kw_args),
                &block
      end

      # See https://design-system.service.gov.uk/components/details/
      # Defines a section for a gds details component whose specification matches that of the section of
      # the I18n file pointed to by specification.
      # The only specification keys used are
      #  - label - The text for the collapsible link for the details
      #   @return [EtTestHelpers::Components::GovUKDetails] The site prism section
      def gds_details(name, specification, **kw_args, &block)
        section name,
                govuk_component(:details),
                :govuk_details,
                specification,
                **DEFAULT_FIND_OPTIONS.merge(kw_args),
                &block
      end

      # See https://design-system.service.gov.uk/components/file-upload/
      # Defines a section for a gds file upload component whose specification matches that of the section of
      # the I18n file pointed to by specification.
      # The only specification keys used are
      # - label - The visual label for the file input field (i.e. the label attached to it)
      # - hint - If specified, the file input field should have a hint matching this text to be valid
      # - errors - An object containing the different errors that can be shown - matched using has_error?
      # @return [EtTestHelpers::Components::GovUKFileField] The site prism section
      def gds_file_upload(name, specification, **kw_args, &block)
        section name,
                govuk_component(:file_field),
                :govuk_file_field,
                specification,
                **DEFAULT_FIND_OPTIONS.merge(kw_args),
                &block
      end

      # See https://design-system.service.gov.uk/components/file-upload/
      # Defines a section for a gds file dropzone upload component whose specification matches that of the section of
      # the I18n file pointed to by specification.
      # The only specification keys used are
      # - label - The visual label for the file input field (i.e. the label attached to it)
      # - hint - If specified, the file input field should have a hint matching this text to be valid
      # - errors - An object containing the different errors that can be shown - matched using has_error?
      # @return [EtTestHelpers::Components::GovUKFileDropzoneField] The site prism section
      def gds_file_dropzone_upload(name, specification, **kw_args, &block)
        section name,
                govuk_component(:file_dropzone_field),
                :govuk_file_dropzone_field,
                specification,
                **DEFAULT_FIND_OPTIONS.merge(kw_args),
                &block
      end

      # See https://design-system.service.gov.uk/components/textarea/
      # Defines a section for a gds text area component whose specification matches that of the section of
      # the I18n file pointed to by specification.
      # The only specification keys used are
      # - label - The visual label for the text area (i.e. the label attached to it)
      # - hint - If specified, the text area should have a hint matching this text to be valid
      # - errors - An object containing the different errors that can be shown - matched using has_error?
      #   @return [EtTestHelpers::Components::GovUKTextArea] The site prism section
      def gds_text_area(name, specification, **kw_args, &block)
        section name,
                govuk_component(:text_area, scope: specification),
                :govuk_text_area,
                specification,
                **DEFAULT_FIND_OPTIONS.merge(kw_args),
                &block
      end

      # See https://design-system.service.gov.uk/components/radios/
      # Defines a section for gds radios component whose specification matches that of the section of
      # the I18n file pointed to by specification.
      # @param [Symbol] name The name of the primary method to be defined in order to access this component
      # @param [Symbol, Hash, String] specification The symbol, hash or string to identify the component
      # The only specification keys used are
      # @option specification [String] :label The visual label for the group of radio buttons (i.e. the legend attached to the fieldset for this group)
      # @option specification [String] :hint If specified, the group of radio buttons should have a hint matching this text to be valid
      # @option specification [Hash] :errors A hash containing the different errors that can be shown - matched using has_error?
      # @option specification [Hash] :options A hash containing the different options the group should have
      # @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
      def gds_radios(name, specification, **kw_args, &block)
        section name,
                govuk_component(:collection_radio_buttons, scope: specification),
                :govuk_collection_radio_buttons,
                specification,
                **DEFAULT_FIND_OPTIONS.merge(kw_args),
                &block
      end

      # See https://design-system.service.gov.uk/components/checkboxes/
      # Defines a section for gds checkboxes component whose specification matches that of the section of
      # the I18n file pointed to by specification.
      # @param [Symbol] name The name of the primary method to be defined in order to access this component
      # @param [Symbol, Hash, String] specification The symbol, hash or string to identify the component
      # The only specification keys used are
      # @option specification [String] :label The visual label for the group of check boxes (i.e. the legend attached to the fieldset for this group)
      # @option specification [String] :hint If specified, the group of check boxes should have a hint matching this text to be valid
      # @option specification [Hash] :errors A hash containing the different errors that can be shown - matched using has_error?
      # @option specification [Hash] :options A hash containing the different options the group should have
      # @return [EtTestHelpers::Components::GovUKCollectionCheckBoxes] The site prism section
      def gds_checkboxes(name, specification, **kw_args, &block)
        section name,
                govuk_component(:collection_check_boxes, scope: specification),
                :govuk_collection_check_boxes,
                specification,
                **DEFAULT_FIND_OPTIONS.merge(kw_args),
                &block
      end

      # Defines a section for gds checkbox component whose specification matches that of the section of
      # the I18n file pointed to by specification.
      # @param [Symbol] name The name of the primary method to be defined in order to access this component
      # @param [Symbol, Hash, String] specification The symbol, hash or string to identify the component
      # The only specification keys used are
      # @option specification [String] :label The visual label for the check box
      # @option specification [String] :hint If specified, the check box should have a hint matching this text to be valid
      # @option specification [Hash] :errors A hash containing the different errors that can be shown - matched using has_error?
      # @option specification [Hash] :options A hash containing the different options the group should have
      # @return [EtTestHelpers::Components::GovUKCheckbox] The site prism section
      def gds_checkbox(name, specification, **kw_args, &block)
        section name,
                govuk_component(:checkbox),
                :govuk_checkbox,
                specification,
                **DEFAULT_FIND_OPTIONS.merge(kw_args),
                &block
      end

      # See https://design-system.service.gov.uk/components/select/
      # Defines a section for a gds select component whose specification matches that of the section of
      # the I18n file pointed to by specification.
      # @param [Symbol] name The name of the primary method to be defined in order to access this component
      # @param [Symbol, Hash, String] specification The symbol, hash or string to identify the component
      # The only specification keys used are
      # @option specification [String] :label The visual label for the select field (i.e. the label attached to it)
      # @option specification [String] :hint If specified, the select field should have a hint matching this text to be valid
      # @option specification [Hash] :errors A hash containing the different errors that can be shown - matched using has_error?
      # @option specification [Hash] :options A hash containing the different options the select field should have
      # @return [EtTestHelpers::Components::GovUKCollectionSelect] The site prism section
      def gds_select(name, specification, **kw_args, &block)
        section name,
                govuk_component(:collection_select, scope: specification),
                :govuk_collection_select,
                specification,
                **DEFAULT_FIND_OPTIONS.merge(kw_args),
                &block
      end

      # See https://design-system.service.gov.uk/components/date-input/
      # Defines a section for a gds date input component whose specification matches that of the section of
      # the I18n file pointed to by specification.
      # @param [Symbol] name The name of the primary method to be defined in order to access this component
      # @param [Symbol, Hash, String] specification The symbol, hash or string to identify the component
      # The only specification keys used are
      # @option specification [String] :label The visual label for the date input field (i.e. the legend attached to the group surrounding the input elements)
      # @option specification [String] :hint If specified, the date input field should have a hint matching this text to be valid
      # @option specification [Hash] :errors A hash containing the different errors that can be shown - matched using has_error?
      # @option specification [Hash] :options A hash containing keys :day, :month and :year which specify the labels for the relevant fields
      # @return [EtTestHelpers::Components::GovUKDateField] The site prism section
      def gds_date_input(name, specification, **kw_args, &block)
        section name,
                govuk_component(:date_field, scope: specification),
                :govuk_date_field,
                specification,
                **DEFAULT_FIND_OPTIONS.merge(kw_args),
                &block
      end

      # Defines a section for a gds email input component whose specification matches that of the section of
      # the I18n file pointed to by specification.
      # @param [Symbol] name The name of the primary method to be defined in order to access this component
      # @param [Symbol, Hash, String] specification The symbol, hash or string to identify the component
      # The only specification keys used are
      # @option specification [String] :label The visual label for the email input field (i.e. the label attached to it)
      # @option specification [String] :hint If specified, the email input field should have a hint matching this text to be valid
      # @option specification [Hash] :errors A hash containing the different errors that can be shown - matched using has_error?
      # @return [EtTestHelpers::Components::GovUKEmailField] The site prism section
      def gds_email_input(name, specification, **kw_args, &block)
        section name,
                govuk_component(:email_field),
                :govuk_email_field,
                specification,
                **DEFAULT_FIND_OPTIONS.merge(kw_args),
                &block
      end

      # Defines a section for a gds phone input component whose specification matches that of the section of
      # the I18n file pointed to by specification.
      # @param [Symbol] name The name of the primary method to be defined in order to access this component
      # @param [Symbol, Hash, String] specification The symbol, hash or string to identify the component
      # The only specification keys used are
      # @option specification [String] :label The visual label for the phone input field (i.e. the label attached to it)
      # @option specification [String] :hint If specified, the phone input field should have a hint matching this text to be valid
      # @option specification [Hash] :errors A hash containing the different errors that can be shown - matched using has_error?
      # @return [EtTestHelpers::Components::GovUKPhoneField] The site prism section
      def gds_phone_input(name, specification, **kw_args, &block)
        section name,
                govuk_component(:phone_field),
                :govuk_phone_field,
                specification,
                **DEFAULT_FIND_OPTIONS.merge(kw_args),
                &block
      end
    end
  end
end
