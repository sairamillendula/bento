class BootstrapSidebarNavBuilder < TabsOnRails::Tabs::Builder
  def open_tabs(options = {})
      @context.tag("ul", options, open = true)
    end

  def close_tabs(options = {})
    "</ul>".html_safe
  end

  def tab_for(tab, name, icon, options, item_options = {})
    item_options[:class] = (current_tab?(tab) ? 'active' : '')
    @context.content_tag(:li, item_options) do
      @context.icon_link_to(name, icon, options)
    end
  end
end