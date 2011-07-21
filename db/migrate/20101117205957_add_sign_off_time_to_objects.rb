class AddSignOffTimeToObjects < ActiveRecord::Migration
  def self.up
    add_column :pages, :signed_off_at, :datetime
    add_column :pictures, :signed_off_at, :datetime
    add_column :categories, :signed_off_at, :datetime
    add_column :users, :signed_off_at, :datetime
  end

  def self.down
    remove_column :users, :signed_off_at
    remove_column :categories, :signed_off_at
    remove_column :pictures, :signed_off_at
    remove_column :pages, :signed_off_at
  end
end
