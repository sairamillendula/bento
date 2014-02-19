namespace :scheduled_jobs do

  # rake scheduled_jobs:remove_old_carts
  desc "Clean up old abandonned carts"
  task :remove_old_carts => :environment do

    carts = Cart.where('created_at >= ?', Date.today - 30.days)
    carts.destroy_all
    puts "**** deleted old carts ****"
  end

end