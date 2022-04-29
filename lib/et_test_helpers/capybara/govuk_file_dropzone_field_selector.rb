Capybara.add_selector(:govuk_file_dropzone_field) do
  label 'GOVUK GDS File dropzone field container labelled'
  xpath do |locator, translation_options: {}, **options|
    locator = ::EtTestHelpers.normalize_locator(locator, translation_options: translation_options)
    locator = locator[:label] if locator.is_a?(Hash)

    # Helps with nicer error messages from rspec etc..
    @definition.label("GOVUK GDS File dropzone field container labelled <#{locator}>")
    xpath = XPath.generate { |x| x.descendant(:div)[x.attr(:'data-module').equals('et-gds-design-system-dropzone-uploader') & x.attr(:class).contains_word('dropzone')] }
    field_xpath = locate_field(xpath, locator, **options)
    XPath.generate {|x| x.css('.govuk-form-group')[field_xpath] }
  end
end
