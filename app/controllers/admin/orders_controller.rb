class Admin::OrdersController < Admin::BaseController
  set_tab :orders
  helper_method :sort_column, :sort_direction

  def index
    @orders = Order.includes(:client).order(sort_column + " " + sort_direction).page(params[:page]).per(20)

    respond_to do |format|
      format.html
      format.pdf do
        pdf = OrdersPdf.new(@orders)
        send_data pdf.render, filename: "#{t 'order'}.pdf", type: "application/pdf", disposition: "inline"
      end
    end
  end

  def show
    @order = Order.includes(:client, :audits, :shipping_address, :billing_address).find(params[:id])

    respond_to do |format|
      format.html
      format.pdf do
        pdf = OrdersPdf.new([@order])
        send_data pdf.render, filename: "#{t 'order'} ##{@order.code}.pdf", type: "application/pdf", disposition: "inline"
      end
    end
  end

  def edit
    @order = Order.includes(:shipping_address, :billing_address).find(params[:id])
  end

  def update
    @order = Order.find(params[:id])

    respond_to do |format|
      if @order.update_attributes(params[:order])
        format.html { redirect_to admin_order_url(@order), notice: 'Order was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def mark_as_shipped
    @order = Order.find(params[:id])
    @order.ship(current_user)

    respond_to do |format|
      if @order.errors.blank?
        format.html { redirect_to admin_order_url(@order), notice: 'Order shipped.' }
        format.js
      else
        format.html { render action: "index", notice: 'An error occured. Please try again.' }
        format.js
      end
    end
  end

  def cancel
    @order = Order.find(params[:id])
    @order.cancel(current_user)

    respond_to do |format|
      if @order.errors.blank?
        format.html { redirect_to admin_order_url(@order), notice: 'Order cancelled.' }
        format.js
      else
        format.html { render action: "index", notice: 'An error occured. Please try again.' }
        format.js
      end
    end
  end

  def print
    # find by id: params[:order_ids]
    # send to pdf
  end

private

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

  def sort_column
    Order.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end

end