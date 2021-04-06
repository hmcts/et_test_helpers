Capybara.add_selector(:govuk_collection_radio_buttons) do
  label 'GOVUK GDS Collection radio buttons labelled'
  xpath do |locator, **options|
    locator = ::EtTestHelpers.normalize_locator(locator)
    locator = locator[:label] if locator.is_a?(Hash)

    # Helps with nicer error messages from rspec etc..
    @definition.label("GOVUK GDS Collection radio buttons labelled <#{locator}>")
    XPath.generate { |x| x.descendant(:div)[x.attr(:class).contains_word('govuk-form-group') & x.child(:fieldset)[x.attr(:class).contains_word('govuk-fieldset') & x.child(:legend)[x.string.n.equals(locator)]]] }
  end
end
