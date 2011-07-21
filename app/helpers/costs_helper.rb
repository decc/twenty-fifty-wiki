module CostsHelper
    
  def update_year(*years)
    raw(years.map do |year|
      update_field 'cost_valid_in_year', year
    end.join(' or '))
  end

  def update_fuel_to(cost)
    update_field 'cost_fuel', cost
  end

  def update_fuel_limit_to(limit)
    update_field 'cost_valid_for_quantity_of_fuel', limit
  end
  
  def update_capacity_to(size)
    update_field 'cost_size', size
  end

  def update_life_to(life)
    update_field 'cost_life', life
  end

  def update_efficiency_to(output)
    update_field 'cost_efficiency', output
  end

  def update_output_to(output)
    update_field 'cost_output', output
  end  
  
  def update_label_to(new_label)
    update_field 'cost_label', new_label
  end
  
  def update_operating_to(cost)
    update_field 'cost_operating', cost
  end
  
  def update_capital_to(cost)
    update_field 'cost_capital', cost
  end

  def update_category_to(cost_category)
    update_field 'cost_cost_category_label', cost_category.label, cost_category.label, "$('cost_cost_type_#{cost_category.cost_type}').checked = true;#{cost_category.cost_type == :fuel ? 'makeFuelCostForm()' : 'makeTechnologyCostForm()'};setContentIfUnchanged(#{cost_category.cost_boilerplate.to_json})"
  end
end
