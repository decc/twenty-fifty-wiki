class AddUserToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :user_id, :integer
    User.all.each do |user|
      user.update_attribute(:user_id,user.id)
    end
  end

  def self.down
    remove_column :users, :user_id
  end
end
