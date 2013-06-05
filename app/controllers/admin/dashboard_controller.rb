class Admin::DashboardController < Admin::BaseController
  set_tab :dashboard
  
  def show
    @users = User.normal
    @today_users = @users.today
    @weekly_users = @users.weekly
    @monthly_users = @users.monthly

    @orders = Order.completed
    @today_orders = @orders.by_day(Date.today)
    @weekly_orders = @orders.within_period(Date.today.beginning_of_week, Date.today.end_of_week)
    @monthly_orders = @orders.by_month(Date.today)
  end

  def search
    @results = PgSearch.multisearch(params[:query]).page(params[:page] || 1).per(20)
  end

end