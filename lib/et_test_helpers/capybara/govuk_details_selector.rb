Capybara.add_selector(:govuk_details) do
  label 'GOVUK GDS details labelled'
  xpath do |locator, **options|
    locator = ::EtTestHelpers.normalize_locator(locator)
    locator = locator[:label] if locator.is_a?(Hash)

    # Helps with nicer error messages from rspec etc..
    @definition.label("GOVUK GDS details labelled <#{locator}>")
    XPath.generate { |x| x.css('details.govuk-details')[x.child(:summary)[x.string.n.equals(locator)]] }
  end
end
