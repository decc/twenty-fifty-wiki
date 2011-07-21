class AddNameToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :title, :string
    add_column :users, :sortable_name, :string
    
    add_index :users, :title
    add_index :users, :sortable_name
  end

  def self.down
    remove_column :users, :sortable_name
    remove_column :users, :name
  end
end
