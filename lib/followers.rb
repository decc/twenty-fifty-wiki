module Followers
  def self.included(base)
     base.instance_eval do
       has_many :followings, :as => :target, :dependent => :destroy
       has_many :followers, :through => :followings, :source => :user, :uniq => true
     end
   end
   
   def followed_by_current_user?
     followers.include?(User.current)
   end
   
  def follow!
    user = User.current || self
    return true unless user.is_a?(User)
    return true if followers.include?(user)
    followers << user
    true
  end
   
   def un_follow!
     followers.delete(User.current)
   end
     
end
