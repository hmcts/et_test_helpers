Capybara.add_selector(:govuk_collection_select) do
  label 'GOVUK GDS Collection select container labelled'
  xpath do |locator, **options|
    locator = ::EtTestHelpers.normalize_locator(locator)
    locator = locator[:label] if locator.is_a?(Hash)

    # Helps with nicer error messages from rspec etc..
    @definition.label("GOVUK GDS Collection select container labelled <#{locator}>")
    xpath = XPath.generate { |x| x.descendant(:select)[x.attr(:class).contains_word('govuk-select')] }
    field_xpath = locate_field(xpath, locator, **options)
    XPath.generate {|x| x.css('.govuk-form-group')[field_xpath] }
  end
end
