class AddSignOffToVersionControll < ActiveRecord::Migration
  def self.up
    add_column :versions, :signed_off_by_id, :integer
    add_column :versions, :signed_off_at, :datetime
  end

  def self.down
    remove_column :versions, :signed_off_at
    remove_column :versions, :signed_off_by_id
  end
end
