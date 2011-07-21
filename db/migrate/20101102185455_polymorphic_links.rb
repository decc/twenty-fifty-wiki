class PolymorphicLinks < ActiveRecord::Migration
  def self.up
    rename_column :links, :to_page_id, :to_id
    rename_column :links, :from_page_id, :from_id
    add_column :links, :to_type, :string
    add_column :links, :from_type, :string
    Link.all.each do |link|
      link.to_type = "Page"
      link.from_type = "Page"
      link.save
    end
  end

  def self.down
    remove_column :links, :from_type
    remove_column :links, :to_type
    rename_column :links, :from_id, :from_page_id
    rename_column :links, :to_id, :to_page_id
    Link.delete_all
  end
end
