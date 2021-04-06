Capybara.add_selector(:govuk_radio_button) do
  label 'GOVUK GDS radio button labelled'
  xpath do |locator, **options|
    locator = ::EtTestHelpers.normalize_locator(locator)
    locator = locator[:label] if locator.is_a?(Hash)
    # Helps with nicer error messages from rspec etc..
    @definition.label("GOVUK GDS radio button labelled <#{locator}>")
    xpath = XPath.generate { |x| x.child(:input)[x.attr(:type).equals('radio')] }
    field_xpath = locate_field(xpath, locator, **options)
    XPath.generate {|x| x.css('.govuk-radios__item')[field_xpath] }
  end
end
