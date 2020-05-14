Capybara.add_selector(:govuk_field_input) do
  label 'GOVUK GDS input'
  xpath do
    XPath.generate { |x| x.child(:input)[x.attr(:class).contains_word('govuk-input')] }
  end
end
