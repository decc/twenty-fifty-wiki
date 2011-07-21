class MakeVersionsPolymorphic < ActiveRecord::Migration
  def self.up
    rename_column :versions, :page_id, :target_id
    add_column :versions, :target_type, :string
    Version.all.each do |version|
      version.target_type = "Page"
      version.save
    end
  end

  def self.down
    remove_column :versions, :target_type
    rename_column :versions, :target_id, :page_id
  end
end
