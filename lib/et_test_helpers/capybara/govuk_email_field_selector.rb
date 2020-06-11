Capybara.add_selector(:govuk_email_field) do
  label 'GOVUK GDS Email field labelled'
  xpath do |locator, **options|
    locator = ::EtTestHelpers.normalize_locator(locator)
    # Helps with nicer error messages from rspec etc..
    @definition.label("GOVUK GDS Email field labelled <#{locator}>")
    xpath = XPath.generate { |x| x.descendant(:input)[x.attr(:type).equals('email') & x.attr(:class).contains_word('govuk-input')] }
    field_xpath = locate_field(xpath, locator, **options)
    XPath.generate {|x| x.css('.govuk-form-group')[field_xpath] }
  end
end