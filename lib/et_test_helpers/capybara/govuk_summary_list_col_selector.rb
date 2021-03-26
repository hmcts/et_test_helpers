Capybara.add_selector(:govuk_summary_list_col) do
  label "GOVUK summary list col labelled"
  xpath do |locator, **options|
    locator = ::EtTestHelpers.normalize_locator(locator)
    # Helps with nicer error messages from rspec etc..
    @definition.label("GOVUK summary list col labelled <#{locator}>")
    XPath.generate { |x| x.descendant(:dt)[x.attr(:class).contains_word('govuk-summary-list__value') & x.string.n.equals(locator)] }
  end
end
