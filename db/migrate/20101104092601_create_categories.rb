class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :title
      t.text :content
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :categories
  end
end
