Capybara.add_selector(:govuk_field_error) do
  label 'GOVUK GDS field error'
  xpath do
    XPath.generate { |x| x.descendant(:span)[x.attr(:class).contains_word('govuk-error-message') & x.child(:span)[x.attr(:class).contains_word('govuk-visually-hidden') & x.string.n.equals('Error:')]] }
  end
end
