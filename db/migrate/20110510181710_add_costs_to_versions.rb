class AddCostsToVersions < ActiveRecord::Migration
  def self.up
    add_column :versions, :label, :string
    add_column :versions, :default_capital_unit, :string
    add_column :versions, :default_operating_unit, :string
    add_column :versions, :default_fuel_unit, :string
    add_column :versions, :capital, :string
    add_column :versions, :operating, :string
    add_column :versions, :fuel, :string
    add_column :versions, :size, :string
    add_column :versions, :life, :string
    add_column :versions, :efficiency, :string
    add_column :versions, :valid_in_year, :string
    add_column :versions, :valid_for_quantity_of_fuel, :string
    add_column :versions, :cost_source_id, :integer
    add_column :versions, :cost_category_id, :integer
  end

  def self.down
    remove_column :versions, :cost_category_id
    remove_column :versions, :cost_source_id
    remove_column :versions, :valid_for_quantity_of_fuel
    remove_column :versions, :valid_in_year
    remove_column :versions, :efficiency
    remove_column :versions, :life
    remove_column :versions, :size
    remove_column :versions, :fuel
    remove_column :versions, :operating
    remove_column :versions, :capital
    remove_column :versions, :default_fuel_unit
    remove_column :versions, :default_operating_unit
    remove_column :versions, :default_capital_unit
    remove_column :versions, :label
  end
end
