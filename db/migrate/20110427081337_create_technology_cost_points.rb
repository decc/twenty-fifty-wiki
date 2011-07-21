class CreateTechnologyCostPoints < ActiveRecord::Migration
  def self.up
    create_table :technology_cost_points do |t|
      t.string :name
      t.text :source
      t.string :capital_cost
      t.string :operating_cost
      t.integer :technology_id

      t.timestamps
    end
  end

  def self.down
    drop_table :technology_cost_points
  end
end
