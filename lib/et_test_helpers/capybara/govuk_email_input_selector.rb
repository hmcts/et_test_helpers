Capybara.add_selector(:govuk_email_input) do
  label 'GOVUK GDS email input'
  xpath do
    XPath.generate do |x|
      x.descendant(:input)[x.attr(:class).contains_word('govuk-input') & x.attr(:type).equals('email')]
    end
  end

  node_filter(:with) do |node, with|
    val = node.value
    (with.is_a?(Regexp) ? with.match?(val) : val == with.to_s).tap do |res|
      add_error("Expected value to be #{with.inspect} but was #{val.inspect}") unless res
    end
  end

  describe_node_filters do |**options|
    " with value #{options[:with].to_s.inspect}" if options.key?(:with)
  end
end
