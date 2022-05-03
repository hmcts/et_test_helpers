Capybara.add_selector(:govuk_link) do
  label 'GOVUK GDS Link labelled'
  xpath do |locator, translation_options: {}, **options|
    locator = ::EtTestHelpers.normalize_locator(locator, translation_options: translation_options)
    locator = locator[:label] if locator.is_a?(Hash)
    # Helps with nicer error messages from rspec etc..
    @definition.label("GOVUK GDS Link labelled <#{locator}>")
    XPath.generate { |x| x.descendant(:a)[x.attr(:class).contains_word('govuk-link') & x.string.n.equals(locator)] }
  end
end
