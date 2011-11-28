class AddCanEditToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :activated, :boolean, :default => false
    add_column :users, :administrator, :boolean, :default => false
  end

  def self.down
    remove_column :users, :activated
    remove_column :users, :administrator
  end
end
