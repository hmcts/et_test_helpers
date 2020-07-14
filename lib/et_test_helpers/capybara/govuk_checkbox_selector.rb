Capybara.add_selector(:govuk_checkbox) do
  label 'GOVUK GDS checkbox container labelled'
  xpath do |locator, **options|
    locator = ::EtTestHelpers.normalize_locator(locator)
    # Helps with nicer error messages from rspec etc..
    @definition.label("GOVUK GDS checkbox container labelled <#{locator}>")
    xpath = XPath.generate { |x| x.child(:input)[x.attr(:type).equals('checkbox') & x.attr(:class).contains_word('govuk-checkboxes__input')] }
    field_xpath = locate_field(xpath, locator, **options)
    XPath.generate {|x| x.css('.govuk-checkboxes__item')[field_xpath] }
  end
end
