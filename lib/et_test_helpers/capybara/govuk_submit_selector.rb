Capybara.add_selector(:govuk_submit) do
  xpath do |locator, **options|
    locator = ::EtTestHelpers.normalize_locator(locator)
    # Helps with nicer error messages from rspec etc..
    XPath.generate { |x| x.descendant(:input)[x.attr(:class).contains_word('govuk-button') & x.attr(:value).equals(locator)] }
  end
end
