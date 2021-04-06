Capybara.add_selector(:govuk_submit) do
  label "GOVUK submit button labelled"
  xpath do |locator, **options|
    locator = ::EtTestHelpers.normalize_locator(locator)
    locator = locator[:label] if locator.is_a?(Hash)
    # Helps with nicer error messages from rspec etc..
    @definition.label("GOVUK submit button labelled <#{locator}>")
    XPath.generate { |x| x.descendant(:input)[x.attr(:class).contains_word('govuk-button') & x.attr(:value).equals(locator)] }
  end
end
