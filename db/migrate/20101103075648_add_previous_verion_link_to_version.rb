class AddPreviousVerionLinkToVersion < ActiveRecord::Migration
  def self.up
    add_column :versions, :previous_version_id, :integer
    Page.all.each do |page|
      page.versions.each.with_index do |version,index|
        if index > 1
          version.update_attribute(:previous_version_id,page.versions[index-1].try(:id))
        end
      end
    end
  end

  def self.down
    remove_column :versions, :previous_version_id
  end
end
