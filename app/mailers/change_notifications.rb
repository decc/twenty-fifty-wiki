class ChangeNotifications < ActionMailer::Base
  default :from => AppConfig.email_address_to_send_from
  
  def self.send_all_change_notifications
    User.all.each do |user|
      versions = user.followed_versions
      unless versions.empty?
        ChangeNotifications.changes(user,versions).deliver
      end
    end
  end
  
  def changes(user,versions)
    @user = user
    @versions = versions
    mail :to => @user.email
  end
  
  def new_user(user)
    @user = user
    mail :to => AppConfig.email_address_to_send_new_user_notifications_to
  end

  def account_activated(user)
    @user = user
    mail :to => @user.email
  end
end
