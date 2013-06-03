# encoding: utf-8

class OrdersPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper

  PAGE_WIDTH = 752
  FONT_SIZE = 11

  def initialize(orders)
    super(top_margin: 20, left_margin: 20, right_margin: 20, bottom_margin: 20, page_layout: :landscape)
    @orders = orders

    default_leading 2

    layout
  end

  def layout
    define_grid(columns: 2, rows: 1, gutter: 20)

    groups = @orders.in_groups_of(2)
    groups.each_with_index do |group, index|
      grid(0,0).bounding_box do
        if (order = group.first)
          receipt(order)
        end
      end
      grid(0,1).bounding_box do
        if (order = group.last)
          receipt(order)
        end
      end

      start_new_page if index != (groups.size - 1)
    end
  end

  def receipt(order)
    header(order)
    move_down 10
    text "Date: #{I18n.l order.created_at, format: :long}", size: 10, align: :right
    move_down 10
    addresses(order)
    move_down 20
    line_items(order)
    move_down 30
    text "#{I18n.t 'orders.thank_you'}!"
  end

  def header(order)
    data = [["#{I18n.t 'theme.site_name'}", "##{order.code}"]]
    
    table(data, width: bounds.width, cell_style: {size: 24, border_width: 0, font_style: :bold }) do
      row(0).column(1).align = :right
    end
  end

  def addresses(order)
    table([[billing_address_block(order), shipping_address_block(order)]]) do
      cells.borders = []
      cell_style = :bold
      row(0).column(0).padding = [0, 10, 0, 0]
    end
  end

  def billing_address_block(order)
    data = [["<b>#{I18n.t 'billing_address'}</b>"]]
    data << ["#{order.billing_address.full_name}"]
    data << ["<i>#{order.billing_address.for_display}</i>"]

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

  def shipping_address_block(order)
    data = [["<b>#{I18n.t 'shipping_address'}</b>"]]
    data << ["#{order.shipping_address.full_name}"]
    data << ["<i>#{order.shipping_address.for_display}</i>"]

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

  def line_items(order)
    move_down 20
    table(line_item_rows(order), width: bounds.width) do
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
    text "#{I18n.t 'subtotal'}: #{price(order.subtotal)}", style: :bold, size: FONT_SIZE, align: :right
    move_down 5
    if order.coupon_code.present?
      text "#{I18n.t 'discount'} (#{order.coupon_percentage? ? percentage(order.coupon_amount): price(order.coupon_amount)}): -#{price(order.coupon_formatted)}", style: :bold, size: FONT_SIZE, align: :right
      move_down 5
    end
    if order.tax_name.present?
      text "#{order.tax_name}: #{price(order.tax_rate)}", style: :bold, size: FONT_SIZE, align: :right
      move_down 5
    end
    if order.shipping_method.present?
      text "#{I18n.t 'shipping'} (#{order.shipping_method}): #{price(order.shipping_price)}", style: :bold, size: FONT_SIZE, align: :right
      move_down 5
    end
    text "#{I18n.t 'total'}: #{price(order.total)}", style: :bold, size: FONT_SIZE, align: :right
    move_down 5
    text "#{I18n.t 'amount_due'}: #{price(0)}", style: :bold, size: FONT_SIZE, align: :right
  end

  def price(num)
    number_to_currency(num)
  end

  def percentage(num)
    number_to_percentage(num, precision: 0)
  end

  def line_item_rows(order)
    [["Product", "Qty", "Unit Price", "Full Price"]] +
    order.items.map do |item|
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