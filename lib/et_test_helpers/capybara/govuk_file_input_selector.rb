Capybara.add_selector(:govuk_file_input) do
  label 'GOVUK GDS file input'
  xpath do
    XPath.generate { |x| x.descendant(:input)[x.attr(:class).contains_word('govuk-file-upload')] }
  end

  node_filter(:with) do |node, with|
    val = node.value
    (with.is_a?(Regexp) ? with.match?(val) : val.end_with?(File.basename(with.to_s))).tap do |res|
      add_error("Expected value to be #{with.inspect} but was #{val.inspect}") unless res
    end
  end

  describe_node_filters do |**options|
    " with value #{options[:with].to_s.inspect}" if options.key?(:with)
  end
end
