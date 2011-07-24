# encoding: utf-8
require 'spec_helper'

describe Cost do
  it "should be able to convert output and capacity into output as a percentage of peak power, or return nil" do
    Cost.new.output_over_capacity.should == nil
    c = Cost.new
    c.output = "  "
    c.output_over_capacity.should == nil
    c.output = " 10 % "
    c.output_over_capacity.should == 0.1
    c.output = "1.03% "
    c.output_over_capacity.should == 0.0103
    c.output = "3 TWh"
    c.output_over_capacity.should == nil
    c.size = "1 GW"
    c.output_over_capacity.should == 0.34223134839151265
    c.output = "8.6 TWh"
    c.output_over_capacity.should == 0.9810631987223363
  end
  
  it "should be able to convert capital costs into those used in the category, or return ?" do
    c = Cost.new
    cc = CostCategory.new
    c.cost_category = cc
    c.capital = "£bn(2010) 10/GW"
    cc.default_capital_unit = "£(2010)bn/GW"
    c.capital_cost_normalised.map(&:to_f).first.should be_within(0.1).of(10)

    # This should work because the presumption is that these are already peak
    c.capital = "£bn(2010) 10/GW"
    cc.default_capital_unit = "£(2010)bn/GWpeak"
    c.capital_cost_normalised.map(&:to_f).first.should be_within(0.1).of(10)

    # Now assumes a conversion factor of 1.0 unless specified    
    # # This should not work, because the presumption is that the capital is peak
    # c.capital = "£bn(2010) 10/GW"
    # cc.default_capital_unit = "£(2010)bn/GWaverage"
    # c.capital_cost_normalised.should == "?"

    # This should  work, because the capital is specified as average
    c.capital = "£bn(2010) 10/GWaverage"
    cc.default_capital_unit = "£(2010)bn/GWaverage"
    c.capital_cost_normalised.map(&:to_f).first.should be_within(0.1).of(10)

    # These should  work, because the peak capital can be converted to an average
    c.capital = "£bn(2010) 10/GW"
    c.output = " 10 % "    
    cc.default_capital_unit = "£(2010)bn/GWaverage"
    c.capital_cost_normalised.map(&:to_f).first.should be_within(0.1).of(100)

    c.capital = "£bn(2010) 10/GW"
    c.size = " 10 GW"
    c.output = " 1 GW "
    cc.default_capital_unit = "£(2010)bn/GWaverage"
    c.capital_cost_normalised.map(&:to_f).first.should be_within(0.1).of(100)
  end
  
  it "should be able to convert operating costs into those used in the category, or return ?" do
    c = Cost.new
    cc = CostCategory.new
    c.cost_category = cc
    c.operating = "£bn(2010) 10/GW"
    cc.default_operating_unit = "£(2010)bn/GW"
    c.operating_cost_normalised.map(&:to_f).first.should be_within(0.1).of(10)

    # This should work because the presumption is that these are already average
    c.operating = "£bn(2010) 10/GW"
    cc.default_operating_unit = "£(2010)bn/GWaverage"
    c.operating_cost_normalised.map(&:to_f).first.should be_within(0.1).of(10)
    
    # Now assumes a conversion factor of 1.0 unless specified
    # # This should not work, because the presumption is that the operating is average
    # c.operating = "£bn(2010) 10/GW"
    # cc.default_operating_unit = "£(2010)bn/GWpeak"
    # c.operating_cost_normalised.should == "?"

    # This should  work, because the operating is specified as average
    c.operating = "£bn(2010) 10/GWpeak"
    cc.default_operating_unit = "£(2010)bn/GWpeak"
    c.operating_cost_normalised.map(&:to_f).first.should be_within(0.1).of(10)

    # These should  work, because the peak operating can be converted to an average
    # c.operating = "£bn(2010) 10/GW"
    # c.output = " 10 % "    
    # cc.default_operating_unit = "£(2010)bn/GWpeak"
    # c.operating_cost_normalised.map(&:to_f).first.should be_within(0.1).of(10)
    # 
    # c.operating = "£bn(2010) 10/GW"
    # c.size = " 10 GW"
    # c.output = " 1 GW "
    # cc.default_operating_unit = "£(2010)bn/GWpeak"
    # c.operating_cost_normalised.map(&:to_f).first.should be_within(0.1).of(1)
  end
  
  it "should be able to normalise valid in year, which means splitting ranges and creating 4 digit years" do
    c = Cost.new
    c.valid_in_year = "2010"
    c.valid_in_year_normalised.should == [2010]
    c.valid_in_year = " 2010- 2050"
    c.valid_in_year_normalised.should == [2010,2050]
    c.valid_in_year = ""
    c.valid_in_year_normalised.should == "?"
    c.valid_in_year = "FOAK"
    c.valid_in_year_normalised.should == [2010]
    c.valid_in_year = "NOAK"
    c.valid_in_year_normalised.should == [2050]
    c.valid_in_year = "20"
    c.valid_in_year_normalised.should == [2020]
    c.valid_in_year = "2010-30"
    c.valid_in_year_normalised.should == [2010,2030]
    c.valid_in_year = "2010-2"
    c.valid_in_year_normalised.should == [2010,2012]
    c.valid_in_year = "2040s"
    c.valid_in_year_normalised.should == [2040,2050]
    c.valid_in_year = "10s"
    c.valid_in_year_normalised.should == [2010,2020]
    c.valid_in_year = "2040s-80s"
    c.valid_in_year_normalised.should == [2040,2090]
  end
  
  it "should be able to report whether it has any data that it couldn't parse" do
    c = Cost.new
    cc = CostCategory.new
    cc.default_capital_unit = "£(2010)bn/GW"
    cc.default_operating_unit = "£(2010)bn/GW"
    cc.default_fuel_unit = "£(2010)/PJ"
    cc.default_valid_for_quantity_of_fuel_unit = "PJ"
    c.cost_category = cc
    
    c.problem_parsing_data?.should == false
    c.valid_in_year = "the thirties"
    c.problem_parsing_data?.should == true
    c.valid_in_year = "30"
    c.problem_parsing_data?.should == false
    c.output = " blah "
    c.problem_parsing_data?.should == true
    c.output = "30%"
    c.problem_parsing_data?.should == false
    c.operating = "blah"
    c.problem_parsing_data?.should == true
    c.operating = "£(2009)1/kW"
    c.problem_parsing_data?.should == false
    c.capital = "blah"
    c.problem_parsing_data?.should == true
    c.capital = "£(2009)1/kW"
    c.problem_parsing_data?.should == false
    c.fuel = "blah"
    c.problem_parsing_data?.should == true
    c.fuel = "€(2001)50/MWh"
    c.problem_parsing_data?.should == false
    c.valid_for_quantity_of_fuel = "blah"
    c.problem_parsing_data?.should == true
    c.valid_for_quantity_of_fuel = "50 MWh"
    c.problem_parsing_data?.should == false
  end
  
end
