module ApplicationHelper

	def submit_or_cancel(form, submit_name = "", cancel_name="#{t 'cancel'}")
    unless submit_name.blank?
      form.submit(submit_name, class: 'btn btn-primary', data: {disable_with: "#{t 'please_wait'}"}) + " #{t 'or'} " + link_to(cancel_name, 'javascript:history.go(-1);', class: 'cancel')
    else
      form.submit(class: 'btn btn-primary', data: {disable_with: "#{t 'please_wait'}"}) + " #{t 'or'} " + link_to(cancel_name, 'javascript:history.go(-1);', class: 'cancel')
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
      renderer = Redcarpet::Render::HTML.new(hard_wrap: true, filter_html: false)
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

  def page_title(title, &block)
    page_actions = block_given? ? capture(&block) : ''
    content_tag(:div, class: "page-title") do
      content_tag(:h1, (title + page_actions).html_safe)
    end
  end

  def page_section(section)
    content_tag(:div, class: "page-section") do
      content_tag(:h1, section)
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
      :title       => "#{t 'theme.site_slogan'} | #{t 'theme.site_name'}",
      :description => "#{t 'theme.site_description'}"
    }
  end

  def format_slug(model)
    model.slug.parameterize.downcase
  end

  def icon_flag(country)
    content_tag(:i, '', class: "famfamfam-flag-#{Country[country].alpha2.downcase}") + " "
  end

  def province_options
    {
      Country['CA'].name => Country['CA'].subdivisions.map {|x| [x.last["name"], x.first]},
      Country['US'].name => Country['US'].subdivisions.map {|x| [x.last["name"], x.first]}
    }
  end

  def price_with_currency(price, currency = ENV['STRIPE_CURRENCY'].upcase)
    price = Money.new(price.to_f.round(2) * 100).exchange_to(currency)
    "#{price.symbol} #{price} #{currency}"
  end

  # set value[:priority] < 100 to limit to major currencies
  def all_currencies
    Money::Currency.table.map{|key, value| [value[:iso_code], value[:iso_code]] if value[:priority] < 100}.compact
  end

  def all_countries
    countries = Country.all.sort_by { |n| n[0] }
    countries.delete(["Worldwide", "WORLDWIDE"])
    countries.unshift(["Worldwide", "WORLDWIDE"])
  end
end