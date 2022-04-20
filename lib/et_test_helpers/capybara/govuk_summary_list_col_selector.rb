Capybara.add_selector(:govuk_summary_list_col) do
  label 'GOVUK summary list col labelled'
  xpath do |locator, **_options|
    locator = ::EtTestHelpers.normalize_locator(locator)
    locator = locator[:label] if locator.is_a?(Hash)
    # Helps with nicer error messages from rspec etc..
    @definition.label("GOVUK summary list col labelled <#{locator}>")
    XPath.generate do |x|
      q = x.attr(:class).contains_word('govuk-summary-list__value')
      q &= x.string.n.equals(locator) unless locator.nil?
      x.descendant(:dd)[q]
    end
  end
end
