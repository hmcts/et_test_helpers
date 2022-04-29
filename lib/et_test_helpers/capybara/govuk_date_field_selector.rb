Capybara.add_selector(:govuk_date_field) do
  label 'GOVUK GDS Date field container labelled'
  xpath do |locator, translation_options: {}, **options|
    locator = ::EtTestHelpers.normalize_locator(locator, translation_options: translation_options)
    locator = locator[:label] if locator.is_a?(Hash)
    # Helps with nicer error messages from rspec etc..
    @definition.label("GOVUK GDS Date field container labelled <#{locator}>")
    XPath.generate { |x| x.descendant(:div)[x.attr(:class).contains_word('govuk-form-group') & x.child(:fieldset)[x.attr(:class).contains_word('govuk-fieldset') & x.child(:legend)[x.string.n.equals(locator)]]] }
  end
end
