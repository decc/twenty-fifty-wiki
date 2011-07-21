class CreateTitles < ActiveRecord::Migration
  def self.up
    create_table :titles do |t|
      t.string :title
      t.integer :length
      t.string :target_type
      t.integer :target_id

      t.timestamps
    end
  end

  def self.down
    drop_table :titles
  end
end
