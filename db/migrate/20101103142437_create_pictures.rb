class CreatePictures < ActiveRecord::Migration
  def self.up
    create_table :pictures do |t|
      t.string :title
      t.text :content
      t.integer :user_id
      t.string :picture_file_name
      t.string :picture_content_type
      t.integer :picture_file_size
      t.datetime :picture_updated_at

      t.timestamps
    end
    Page.where(:is_picture => true).each do |page|
      picture = Picture.new
      %w{title content picture}.each do |attr|
        picture[attr] = page[attr]
      end
      picture.save!
      page.destroy
    end
  end

  def self.down
    drop_table :pictures
  end
end
