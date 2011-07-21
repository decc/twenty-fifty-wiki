class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string :title
      t.text :content
      t.belongs_to :user

      # To speed up searching
      t.string :lowercase_title
      
      # For the version history
      t.integer :latest_version_number
            
      # For when the page is actually a picture with a capture
      t.boolean :is_picture
      t.string :picture_file_name
      t.string :picture_content_type
      t.integer :picture_file_size
      t.datetime :picture_updated_at
      
      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end
