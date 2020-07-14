Capybara.add_selector(:govuk_field_select) do
  label 'GOVUK GDS select'
  xpath do
    XPath.generate { |x| x.descendant(:select)[x.attr(:class).contains_word('govuk-select')] }
  end
end