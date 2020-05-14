Capybara.add_selector(:govuk_field_hint) do
  label 'GOVUK GDS field hint'
  xpath do
    XPath.generate { |x| x.child(:span)[x.attr(:class).contains_word('govuk-hint')] }
  end
end
