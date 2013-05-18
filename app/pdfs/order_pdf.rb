# encoding: utf-8

class OrderPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper
  #include ApplicationHelper

  PAGE_WIDTH = 572
  FONT_SIZE = 11

  def initialize(order)
    super(top_margin: 20, left_margin: 20, right_margin: 20, bottom_margin: 20, page_layout: :portrait)
    @order = order

    default_leading 2

    page_layout
  end

  def page_layout    
    define_grid(columns: 2, rows: 1, gutter: 10)
    grid(0,0).bounding_box do
    	header
    	move_down 10
      text "Date: #{I18n.l @order.created_at, format: :long}", size: 10, align: :right
      move_down 10
      addresses
      move_down 20
      line_items
      move_down 30
      text "#{I18n.t 'orders.thank_you'}!"
    end
    grid(0,1).bounding_box do
      header
    end
    move_down 20

    ### TEST ###
    string = "#{@order.code}"
  	string2 = "#{@order.code}"
  	y_position = cursor - 20
    bounding_box([572, bounds.height-1], width: bounds.width, height: bounds.height/2, rotate: 270) do
      #stroke_bounds
      #stroke_circle [0, 0], 10
      text "##{@order.code}", size: 24, style: :bold, rotate: 270
      line_items
      #hr
    end

    bounding_box([572, bounds.height/2], width: 400, height: bounds.height/2, rotate: 270) do
      #stroke_bounds
      #stroke_circle [0, 0], 10
      text "##{@order.code}", size: 24, style: :bold, rotate: 270
      #hr
    end
  end

  def header
  	data = [["#{I18n.t 'site_name'}", "##{@order.code}"]]
  	
    table(data, width: bounds.width, cell_style: {size: 24, border_width: 0, font_style: :bold }) do
    	row(0).column(1).align = :right
    end
  end

  def addresses
    table([[billing_address_block, shipping_address_block]]) do
      cells.borders = []
      cell_style = :bold
      row(0).column(0).padding = [0, 10, 0, 0]
    end
  end

  def billing_address_block
    data = [["<b>#{I18n.t 'billing_address'}</b>"]]
    data << ["#{@order.billing_address.full_name}"]
    data << ["<i>#{@order.billing_address.for_display}</i>"]

    make_table(data, width: bounds.width/2) do
      cells.inline_format = true
      cells.padding = 10
      cells.size = 11
      cells.style(border_color: "CCCCCC")

      row(0).style(borders: [:top, :left, :right], padding: [10, 10, 0, 10])
      row(1).style(borders: [:left, :right], padding: [10, 10, 0, 10])
      row(2).style(borders: [:left, :right, :bottom], padding: 10)
    end
  end

  def shipping_address_block
  	data = [["<b>#{I18n.t 'shipping_address'}</b>"]]
  	data << ["#{@order.shipping_address.full_name}"]
    data << ["<i>#{@order.shipping_address.for_display}</i>"]

    make_table(data, width: bounds.width/2) do
      cells.inline_format = true
      cells.padding = 10
      cells.size = FONT_SIZE
      cells.style(border_color: "CCCCCC")

      row(0).style(borders: [:top, :left, :right], padding: [10, 10, 0, 10])
      row(1).style(borders: [:left, :right], padding: [10, 10, 0, 10])
      row(2).style(borders: [:left, :right, :bottom], padding: 10)
    end
  end

  def line_items
    move_down 20
    table line_item_rows do
      columns(2..3).align = :right
      cells.borders = []
      row(0..- 2).borders = [:bottom]
      border_width = 1
      row(0).font_style = :bold
      #self.row_colors = ["f3f3f3", "ffffff"]
      self.header = true
      cells.size = FONT_SIZE
    end
    move_down 10
    text "#{I18n.t 'subtotal'}: #{price(@order.subtotal)}", style: :bold, size: FONT_SIZE, align: :right
    move_down 5
    if @order.coupon_code.present?
      text "#{I18n.t 'discount'} (#{@order.coupon_percentage? ? percentage(@order.coupon_amount): price(@order.coupon_amount)}): -#{price(@order.coupon_formatted)}", style: :bold, size: FONT_SIZE, align: :right
      move_down 5
    end
    if @order.tax_name.present?
    	text "#{@order.tax_name}: #{price(@order.tax_rate)}", style: :bold, size: FONT_SIZE, align: :right
      move_down 5
    end
    if @order.shipping_method.present?
    	text "#{I18n.t 'shipping'} (#{@order.shipping_method}): #{price(@order.shipping_price)}", style: :bold, size: FONT_SIZE, align: :right
      move_down 5
    end
    text "#{I18n.t 'total'}: #{price(@order.total)}", style: :bold, size: FONT_SIZE, align: :right
    move_down 5
    text "#{I18n.t 'amount_due'}: #{price(0)}", style: :bold, size: FONT_SIZE, align: :right
  end

  def price(num)
    number_to_currency(num)
  end

  def percentage(num)
  	number_to_percentage(num, precision: 0)
  end

  def line_item_rows
  	[["Product", "Qty", "Unit Price", "Full Price"]] +
    @order.items.map do |item|
      [
      	item.buyable.name,
        item.quantity,
        price(item.price),
        price(item.subtotal)
      ]
    end
  end

  def hr
    move_down 10
    stroke_color "CCCCCC"
    stroke_horizontal_rule
  end
end