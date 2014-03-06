# encoding: utf-8

class ResellerCataloguePdf < Prawn::Document
  include ActionView::Helpers::NumberHelper

  PAGE_WIDTH = 572
  FONT_SIZE = 11

  def initialize(products)
    super(top_margin: 20, left_margin: 20, right_margin: 20, bottom_margin: 20, page_layout: :portrait)
    @products = products

    default_leading 2

    layout
  end

  def layout
    header
    move_down 20
    products
  end

  def header
    text "#{I18n.t 'theme.site_name'} - Reseller Catalogue - #{Time.now.year}"
    hr(1)
  end

  def products
    text "test"
    lines = []
    data = []
    @products.each do |product|
      if product.pictures.any?
        logo = Rails.root.join("public", "upload", "pictures", product.id.to_s, "thumb", product.pictures.first.upload_file_name).to_s
        data << [ { image: logo, scale: 0.4 } ]
      end
      data << ['data', "#{product.name}", "#{product.description}"]
    end
    make_table([[data]], cell_style: {border_color: "FFFFFF"}) do
      # cells.padding = [10, 10, 10, 10]
      #rows(1).size = 9
    end
    #table( [ [lines] ] )

    # products_table = make_table(lines, width: 170, cell_style: {border_color: "FFFFFF"}) do
    #   cells.size = 10
    #   cells.inline_format = true
    #   cells.align = :right
    # end
  end

  def hr(line_width)
    move_down 10
    stroke_color "CCCCCC"
    stroke do
      horizontal_rule
      line_width line_width
    end
  end
end