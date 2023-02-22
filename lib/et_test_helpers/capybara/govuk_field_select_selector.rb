Capybara.add_selector(:govuk_field_select) do
  label 'GOVUK GDS select'
  xpath do
    XPath.generate { |x| x.descendant(:select)[x.attr(:class).contains_word('govuk-select')] }
  end

  node_filter(:selected) do |node, selected|
    actual = options_text(node, visible: false, &:selected?)
    (Array(selected).sort == actual.sort).tap do |res|
      add_error("Expected #{selected.inspect} to be selected found #{actual.inspect}") unless res
    end
  end

  describe_node_filters do |**_options|
    " with #{selected.inspect} selected" if selected
  end

  def options_text(node, **opts, &filter_block)
    opts[:wait] = false
    opts[:visible] = false unless node.visible?
    node.all(:xpath, './/option', **opts, &filter_block).map do |o|
      o.text((:all if opts[:visible] == false))
    end
  end
end
