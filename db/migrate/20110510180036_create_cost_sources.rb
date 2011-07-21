class CreateCostSources < ActiveRecord::Migration
  def self.up
    create_table :cost_sources do |t|
      t.string :title
      t.text :content
      t.integer :user_id
      t.boolean :deleted
      t.integer :signed_off_by_id
      t.datetime :signed_off_at

      t.string :label
      
      t.timestamps
    end
  end

  def self.down
    drop_table :cost_sources
  end
end
