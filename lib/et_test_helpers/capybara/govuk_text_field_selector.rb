Capybara.add_selector(:govuk_text_field) do
  label 'GOVUK GDS Text field container'
  xpath do |locator, **options|
    xpath = XPath.generate { |x| x.descendant(:input)[x.attr(:type).equals('text') & x.attr(:class).contains_word('govuk-input')] }
    field_xpath = locate_field(xpath, locator, **options)
    XPath.generate {|x| x.css('.govuk-form-group')[field_xpath] }
  end
end
