class CreateCostCategories < ActiveRecord::Migration
  def self.up
    create_table :cost_categories do |t|
      t.string :title
      t.text :content
      t.integer :user_id
      t.boolean :deleted
      t.integer :signed_off_by_id
      t.datetime :signed_off_at

      t.string :label      
      t.string :default_capital_unit
      t.string :default_operating_unit
      t.string :default_fuel_unit

      t.timestamps
    end
  end

  def self.down
    drop_table :cost_categories
  end
end
