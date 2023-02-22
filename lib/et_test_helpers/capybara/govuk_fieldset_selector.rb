Capybara.add_selector(:govuk_fieldset) do
  label 'GOVUK GDS Fieldset labelled'
  xpath do |locator, translation_options: {}, **_options|
    locator = ::EtTestHelpers.normalize_locator(locator, translation_options: translation_options)
    locator = locator[:label] if locator.is_a?(Hash)
    # Helps with nicer error messages from rspec etc..
    @definition.label("GOVUK GDS Fieldset labelled <#{locator}>")
    XPath.generate do |x|
      x.descendant(:fieldset)[x.attr(:class).contains_word('govuk-fieldset') & x.child(:legend)[x.string.n.equals(locator)]]
    end
  end
end
