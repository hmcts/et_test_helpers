Capybara.add_selector(:govuk_collection_check_boxes) do
  label 'GOVUK GDS Collection check boxes labelled'
  xpath do |locator, translation_options: {}, **_options|
    locator = ::EtTestHelpers.normalize_locator(locator, translation_options: translation_options)
    locator = locator[:label] if locator.is_a?(Hash)

    # Helps with nicer error messages from rspec etc..
    @definition.label("GOVUK GDS Collection check boxes labelled <#{locator}>")
    XPath.generate do |x|
      x.descendant(:div)[x.attr(:class).contains_word('govuk-form-group') & x.child(:fieldset)[x.attr(:class).contains_word('govuk-fieldset') & x.child(:legend)[x.string.n.equals(locator)]]]
    end
  end
end
