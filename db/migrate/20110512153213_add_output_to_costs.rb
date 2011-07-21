class AddOutputToCosts < ActiveRecord::Migration
  def self.up
    add_column :costs, :output, :string
    add_column :versions, :output, :string
  end

  def self.down
    remove_column :costs, :output
    remove_column :versions, :output
  end
end
