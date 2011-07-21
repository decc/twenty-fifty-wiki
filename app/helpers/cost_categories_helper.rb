module CostCategoriesHelper
  def update_label_to(new_label)
    update_field 'cost_category_label', new_label
  end

  def update_operating_default_to(cost)
    update_field 'cost_category_default_operating_unit', cost
  end

  def update_fuel_default_to(cost)
    update_field 'cost_category_default_fuel_unit', cost
  end

  
  def update_capital_default_to(cost)
    update_field 'cost_category_default_capital_unit', cost
  end
  
  def update_valid_for_quantity_of_fuel_default_to(unit)
    update_field 'cost_category_default_valid_for_quantity_of_fuel_unit', unit
  end
  
end
