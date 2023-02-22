Capybara.add_selector(:govuk_error_summary) do
  xpath do |locator, translation_options: {}, **_options|
    locator = ::EtTestHelpers.normalize_locator(locator, translation_options: translation_options)
    locator = locator[:label] if locator.is_a?(Hash)

    # Helps with nicer error messages from rspec etc..
    XPath.generate do |x|
      x.descendant(:div)[
        x.attr(:class).contains_word('govuk-error-summary') &
        x.descendant(:h2)[x.attr(:class).contains_word('govuk-error-summary__title') & x.string.n.equals(locator)]
      ]
    end
  end
end
