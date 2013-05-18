class Admin::DashboardController < Admin::BaseController
  set_tab :dashboard
  
  def show
    @users = User.normal
    @today_users = @users.today.length
    @weekly_users = @users.weekly.length
    @monthly_users = @users.monthly.length

    @orders = Order.completed
    @today_orders = @orders.by_day(Date.today).length
    @weekly_orders = @orders.within_period(Date.today.beginning_of_week, Date.today.end_of_week).length
    @monthly_orders = @orders.by_month(Date.today).length
  end

end