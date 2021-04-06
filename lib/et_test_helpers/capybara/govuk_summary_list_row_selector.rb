Capybara.add_selector(:govuk_summary_list_row) do
  label "GOVUK summary list row labelled"
  xpath do |locator, **options|
    locator = ::EtTestHelpers.normalize_locator(locator)
    locator = locator[:label] if locator.is_a?(Hash)
    # Helps with nicer error messages from rspec etc..
    @definition.label("GOVUK summary list row labelled <#{locator}>")
    XPath.generate do |x|
      x.descendant[
        x.attr(:class).contains_word('govuk-summary-list__row') &
          x.descendant(:dt)[x.attr(:class).contains_word('govuk-summary-list__key') & x.string.n.equals(locator)]
      ]
    end
  end
end
