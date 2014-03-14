namespace :scheduled_jobs do

  # rake scheduled_jobs:remove_old_carts
  desc "Clean up old abandoned carts"
  task :remove_old_carts => :environment do

    carts = Cart.where('created_at >= ?', Date.today - 30.days)
    carts.destroy_all
    logger = Logger.new(Rails.root + 'log/remove_old_carts.log')
    logger.info "**** #{Time.zone.now.strftime("%Y-%m-%d %H:%M")} deleted old carts (#{carts.length}) ****"
    logger.close
  end

  # rake scheduled_jobs:send_reminder_to_abandoned_carts
  desc "Send reminder to abandoned carts in the hope to recover"
  task :send_reminder_to_abandoned_carts => :environment do

    setting = Setting.abandoned_carts_reminder.to_i
    carts = Cart.with_items.not_reminded.where(created_at: setting.days.ago.beginning_of_day..setting.days.ago.end_of_day)
    carts.each do |cart|
      # let's ignore admin type users
      # make sure we have a valid email address
      unless cart.has_no_email? or (cart.user_id.present? && cart.user.admin?)
        cart.mark_as_reminded
        StoreMailer.remind_cart(cart).deliver
      end
    end
    logger = Logger.new(Rails.root + 'log/send_reminder_to_abandoned_carts.log')
    logger.info "**** #{Time.zone.now.strftime("%Y-%m-%d %H:%M")} reminded abandoned carts (#{carts.length}) ****"
    logger.close
  end

end