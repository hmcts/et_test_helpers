Capybara.add_selector(:govuk_summary_list) do
  label 'GOVUK summary list'
  xpath do |locator, **_options|
    locator = ::EtTestHelpers.normalize_locator(locator)
    locator = locator[:label] if locator.is_a?(Hash)
    @definition.label("GOVUK summary list labelled #{locator}") unless locator.nil?
    XPath.generate do |x|
      q = x.attr(:class).contains_word('govuk-summary-list')
      q &= x.preceding_sibling(:h2)[1][x.string.n.starts_with(locator)] unless locator.nil?
      x.descendant(:dl)[q]
    end
  end
end
