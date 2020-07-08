Capybara.add_selector(:govuk_field_label) do
  label 'GOVUK GDS field label'
  xpath do
    XPath.generate { |x| x.descendant(:label)[x.attr(:class).contains_word('govuk-label')] }
  end
end
