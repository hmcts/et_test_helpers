Capybara.add_selector(:govuk_text_field) do
  label 'GOVUK GDS Text field container labelled'
  xpath do |locator, translation_options: {}, **options|
    locator = ::EtTestHelpers.normalize_locator(locator, translation_options: translation_options)
    locator = locator[:label] if locator.is_a?(Hash)
    # Helps with nicer error messages from rspec etc..
    @definition.label("GOVUK GDS Text field container labelled <#{locator}>")
    xpath = XPath.generate do |x|
      x.descendant(:input)[x.attr(:type).equals('text') & x.attr(:class).contains_word('govuk-input')]
    end
    field_xpath = locate_field(xpath, locator, **options)
    XPath.generate { |x| x.css('.govuk-form-group')[field_xpath] }
  end
end
