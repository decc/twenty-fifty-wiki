class AddAttachmentToVersion < ActiveRecord::Migration
  def change
    add_column :versions, :attachment_file_name, :string
    add_column :versions, :attachment_content_type, :string
    add_column :versions, :attachment_file_size, :integer
    add_column :versions, :attachment_updated_at, :datetime
  end
end
