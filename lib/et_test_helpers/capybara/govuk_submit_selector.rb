Capybara.add_selector(:govuk_submit) do
  label "GOVUK submit button labelled"
  xpath do |locator, translation_options: {}, **options|
    locator = ::EtTestHelpers.normalize_locator(locator, translation_options: translation_options)
    locator = locator[:label] if locator.is_a?(Hash)
    # Helps with nicer error messages from rspec etc..
    @definition.label("GOVUK submit button labelled <#{locator}>")
    XPath.generate { |x| x.descendant(:button)[x.attr(:class).contains_word('govuk-button') & x.string.n.equals(locator)] }
  end
end
