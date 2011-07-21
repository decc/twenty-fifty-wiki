class AddDefaultFuelLimitUnitToCostCategory < ActiveRecord::Migration
  def self.up
    add_column :cost_categories, :default_valid_for_quantity_of_fuel_unit, :string
  end

  def self.down
    remove_column :cost_categories, :default_valid_for_quantity_of_fuel_unit
  end
end