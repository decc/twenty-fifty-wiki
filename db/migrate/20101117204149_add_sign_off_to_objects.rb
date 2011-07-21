class AddSignOffToObjects < ActiveRecord::Migration
  def self.up
    add_column :pages, :signed_off_by_id, :integer
    add_column :pictures, :signed_off_by_id, :integer
    add_column :categories, :signed_off_by_id, :integer
    add_column :users, :signed_off_by_id, :integer
  end

  def self.down
    remove_column :users, :signed_off_by_id
    remove_column :categories, :signed_off_by_id
    remove_column :pictures, :signed_off_by_id
    remove_column :pages, :signed_off_by_id
  end
end
