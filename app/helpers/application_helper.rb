module ApplicationHelper

	def submit_or_cancel(form, submit_name = "", cancel_name="#{t 'cancel'}")
    unless submit_name.blank?
      form.submit(submit_name, class: 'btn btn-primary', "data-disable-with"=>"#{t 'please_wait'}") + " #{t 'or'} " + link_to(cancel_name, 'javascript:history.go(-1);', class: 'cancel')
    else
      form.submit(class: 'btn btn-primary', "data-disable-with"=>"#{t 'please_wait'}") + " #{t 'or'} " + link_to(cancel_name, 'javascript:history.go(-1);', class: 'cancel')
    end
  end
  
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    options = {sort: column, direction: direction}
    options.merge!(params.slice(:search, :day))
    link_to title, options, {class: css_class}
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def markdown(text)
    if text.present?
      renderer = Redcarpet::Render::HTML.new(hard_wrap: true, filter_html: true)
      options = {
        autolink: true,
        tables: true,
        no_intra_emphasis: true,
        fenced_code_blocks: true,
        lax_html_blocks: true,
        strikethrough: true,
        superscript: true
      }
      Redcarpet::Markdown.new(renderer, options).render(text).html_safe
    end
  end

  def page_title(title)
    content_tag(:div, class: "page-header") do
      content_tag(:h1, title)
    end
  end

  def subsection_title(title)
    content_tag(:div, class: "subsection-title") do
      content_tag(:h3, title)
    end
  end

  def status(level)
    status_tag(I18n.t("status.#{level}"), class: "status-#{level}")
  end

  def default_meta_tags
    {
      :title       => "#{t 'site_slogan'} | #{t 'site_name'}",
      :description => "#{t 'site_description'}"
    }
  end

  def format_slug(model)
    model.slug.parameterize.downcase
  end

end