require 'spec_helper'

describe "cost_categories/show.html.haml" do
  before(:each) do
    @cost_category = assign(:cost_category, stub_model(CostCategory,
      :label => "Label",
      :content => "MyText",
      :user_id => 1,
      :deleted => false,
      :signed_off_by_id => 1,
      :default_capital_unit => "Default Capital Unit",
      :default_operating_unit => "Default Operating Unit",
      :default_fuel_unit => "Default Fuel Unit"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Label/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/false/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Default Capital Unit/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Default Operating Unit/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Default Fuel Unit/)
  end
end
