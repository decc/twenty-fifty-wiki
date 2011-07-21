# encoding: utf-8
module CostConversions
  module ClassMethods
  end
  
  def self.included(base)
    base.extend(ClassMethods)
    base.instance_eval do
#      before_save :update_normalised_attributes
    end
  end

  def normalise(cost_as_string)
    NormaliseCost.new(cost_as_string).normalise
  end
  
  def convert(cost_as_string,destination_unit)
    NormaliseCost.new(cost_as_string).convert_to(destination_unit)
  end
  
  def units_from(cost)
    NormaliseCost.new(cost).to_unit()
  end
    
end