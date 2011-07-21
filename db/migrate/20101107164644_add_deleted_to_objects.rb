class AddDeletedToObjects < ActiveRecord::Migration
  def self.up
    add_column :pages, :deleted, :boolean
    add_column :pictures, :deleted, :boolean
    add_column :categories, :deleted, :boolean
    add_column :users, :deleted, :boolean
  end

  def self.down
    remove_column :users, :deleted
    remove_column :categories, :deleted
    remove_column :pictures, :deleted
    remove_column :pages, :deleted
  end
end
