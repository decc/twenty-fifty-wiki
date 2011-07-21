class CreateCosts < ActiveRecord::Migration
  def self.up
    create_table :costs do |t|
      t.string :title
      t.text    :content
      t.integer :user_id
      t.boolean :deleted
      t.integer :signed_off_by_id
      t.datetime :signed_off_at
      
      t.string :label
      t.string :capital
      t.string :operating
      t.string :fuel
      t.string :size
      t.string :life
      t.string :efficiency
      t.string :valid_in_year
      t.string :valid_for_quantity_of_fuel
      t.integer :cost_source_id
      t.integer :cost_category_id

      t.timestamps
    end
  end

  def self.down
    drop_table :costs
  end
end
