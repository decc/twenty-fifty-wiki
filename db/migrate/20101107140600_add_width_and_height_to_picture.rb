class AddWidthAndHeightToPicture < ActiveRecord::Migration
  def self.up
    add_column :pictures, :medium_picture_width, :integer
    add_column :pictures, :medium_picture_height, :integer
    Picture.all.each do |p|
      p.update_picture_dimensions
      p.save
    end
  end

  def self.down
    remove_column :pictures, :medium_picture_height
    remove_column :pictures, :medium_picture_width
  end
end
