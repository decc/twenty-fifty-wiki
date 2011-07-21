require 'spec_helper'

describe "cost_categories/index.html.haml" do
  before(:each) do
    assign(:cost_categories, [
      stub_model(CostCategory,
        :label => "Label",
        :content => "MyText",
        :user_id => 1,
        :deleted => false,
        :signed_off_by_id => 1,
        :default_capital_unit => "Default Capital Unit",
        :default_operating_unit => "Default Operating Unit",
        :default_fuel_unit => "Default Fuel Unit"
      ),
      stub_model(CostCategory,
        :label => "Label",
        :content => "MyText",
        :user_id => 1,
        :deleted => false,
        :signed_off_by_id => 1,
        :default_capital_unit => "Default Capital Unit",
        :default_operating_unit => "Default Operating Unit",
        :default_fuel_unit => "Default Fuel Unit"
      )
    ])
  end

  it "renders a list of cost_categories" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Label".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => false.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Default Capital Unit".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Default Operating Unit".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Default Fuel Unit".to_s, :count => 2
  end
end
