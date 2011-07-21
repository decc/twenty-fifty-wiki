class CreateCategoryMemberships < ActiveRecord::Migration
  def self.up
    create_table :category_memberships do |t|
      t.integer :category_id
      t.integer :dependency_id
      t.string :target_type
      t.integer :target_id

      t.timestamps
    end
  end

  def self.down
    drop_table :category_memberships
  end
end
