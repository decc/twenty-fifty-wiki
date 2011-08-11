module Followers
  def self.included(base)
     base.instance_eval do
       has_many :followings, :as => :target, :dependent => :destroy
       has_many :followers, :through => :followings, :source => :user, :uniq => true
     end
   end
   
  def follow!(user)
    return true unless user.is_a?(User)
    return true if followers.include?(user)
    followers << user
    true
  end
   
   def un_follow!(user)
     followers.delete(user)
   end
     
end
