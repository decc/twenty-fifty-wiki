class AddPictureDimensionsToVersions < ActiveRecord::Migration
  def change
    add_column :versions, :medium_picture_width, :integer
    add_column :versions, :medium_picture_height, :integer
  end
end
