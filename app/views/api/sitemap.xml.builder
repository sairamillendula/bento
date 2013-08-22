xml.instruct!
xml.urlset(xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9") do

  @products.each do |product|
    xml.url do
      xml.loc("#{request.protocol}#{request.host_with_port}#{product_path(product)}")
      xml.changefreq("daily")

      # xml.tag!("dc:creator", product.author_name) if product_has_creator?(product)
    end
  end

  @pages.each do |page|
    xml.url do
      xml.loc("#{request.protocol}#{request.host_with_port}#{page_path(page)}")
      xml.changefreq("weekly")
    end
  end

  @articles.each do |article|
    xml.url do
      xml.loc("#{request.protocol}#{request.host_with_port}#{article_path(article)}")
      xml.changefreq("weekly")
    end
  end
end