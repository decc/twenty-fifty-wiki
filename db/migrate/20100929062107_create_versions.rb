class CreateVersions < ActiveRecord::Migration
  def self.up
    create_table :versions do |t|
      t.belongs_to :page
      t.belongs_to :user
      t.integer :number
      
      # For changes to the page
      t.string :title
      t.text :content
      
      # For change to any associated picture
      t.boolean :is_picture
      t.string :picture_file_name
      t.string :picture_content_type
      t.integer :picture_file_size
      t.datetime :picture_updated_at
      
      t.timestamps
    end

    change_table :versions do |t|
      t.index :page_id
      t.index :user_id
      t.index :number
      t.index :created_at
    end
  end

  def self.down
    drop_table :versions
  end
end
