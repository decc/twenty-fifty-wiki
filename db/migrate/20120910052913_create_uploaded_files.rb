class CreateUploadedFiles < ActiveRecord::Migration
  def change
    create_table :uploaded_files do |t|
      t.string :title
      t.text :content
      t.integer :user_id
      t.boolean :deleted
      t.integer :signed_off_by
      t.datetime :signed_off_at
      t.string :attachment_file_name
      t.string :attachment_content_type
      t.integer :attachment_file_size
      t.datetime :attachment_updated_at

      t.timestamps
    end
  end
end
