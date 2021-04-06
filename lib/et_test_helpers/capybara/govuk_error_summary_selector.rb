Capybara.add_selector(:govuk_error_summary) do
  xpath do |locator, **options|
    locator = ::EtTestHelpers.normalize_locator(locator)
    locator = locator[:label] if locator.is_a?(Hash)

    # Helps with nicer error messages from rspec etc..
    XPath.generate { |x| x.descendant(:div)[x.attr(:class).contains_word('govuk-error-summary') & x.child[x.string.n.equals(locator)]] }
  end
end
