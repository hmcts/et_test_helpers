Capybara.add_selector(:govuk_summary_list) do
  label "GOVUK summary list"
  xpath do |_locator, **options|
    XPath.generate { |x| x.css('.govuk-summary-list') }
  end
end
