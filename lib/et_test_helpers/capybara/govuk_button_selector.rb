Capybara.add_selector(:govuk_button) do
  label "GOVUK button labelled"
  xpath do |locator, **options|
    locator = ::EtTestHelpers.normalize_locator(locator)
    locator = locator[:label] if locator.is_a?(Hash)
    # Helps with nicer error messages from rspec etc..
    @definition.label("GOVUK button labelled <#{locator}>")
    button_locator = XPath.generate { |x| x.attr(:class).contains_word('govuk-button') }
    button_locator = button_locator & XPath.generate { |x| x.string.n.equals(locator) } unless locator.nil?
    XPath.generate { |x| x.descendant(:button)[button_locator] }
  end
end
