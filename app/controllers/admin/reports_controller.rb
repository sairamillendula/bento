# encoding: utf-8
require 'iconv'

class Admin::ReportsController < Admin::BaseController
  helper_method :sort_column, :sort_direction

  def monthly_sales
    set_tab :monthly_sales_report
    @date = params[:month] ? Date.strptime(params[:month], "%Y-%m") : Date.today
    @orders = Order.completed.where(created_at: (@date).beginning_of_month..(@date).end_of_month).order('created_at DESC')

    respond_to do |format|
      format.html
      format.json { render json: @orders }
    end
  end

  def sales
    set_tab :sales_report
    @year = params[:year].blank? ? Date.today.year : params[:year].to_i
    @years = AuditYear.all.map(&:year)
    @years << @year unless @years.include?(@year)
    @years = @years.sort
    @orders_months = Order.completed.where(["YEAR(created_at) = ?", @year])
    @months = @orders_months.group_by{|orders| orders.created_at.month}
  end

  def orders
    set_tab :orders_report
    @search = Order.completed.search(params[:q])
    @orders = @search.result.order('created_at DESC').page(params[:page]).per(15)

    respond_to do |format|
      format.html
      format.csv { 
        content = @orders.to_csv
        content = Iconv.conv('ISO-8859-1','UTF-8', content)
        send_data content, filename: "#{orders.title}.csv", type: 'text/csv; charset=utf-8; header=present'
      }
    end
  end

private

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

  def sort_column
    params[:sort].present? ? params[:sort] : "created_at"
  end

end