require 'spec_helper'

describe "costs/index.html.haml" do
  before(:each) do
    assign(:costs, [
      stub_model(Cost,
        :label => "Label",
        :content => "MyText",
        :user_id => 1,
        :deleted => false,
        :signed_off_by_id => 1,
        :capital => "Capital",
        :operating => "Operating",
        :fuel => "Fuel",
        :size => "Size",
        :life => "Life",
        :efficiency => "Efficiency",
        :valid_in_year => "Valid In Year",
        :valid_for_quantity_of_fuel => "Valid For Quantity Of Fuel",
        :cost_source_id => 1,
        :cost_category_id => 1
      ),
      stub_model(Cost,
        :label => "Label",
        :content => "MyText",
        :user_id => 1,
        :deleted => false,
        :signed_off_by_id => 1,
        :capital => "Capital",
        :operating => "Operating",
        :fuel => "Fuel",
        :size => "Size",
        :life => "Life",
        :efficiency => "Efficiency",
        :valid_in_year => "Valid In Year",
        :valid_for_quantity_of_fuel => "Valid For Quantity Of Fuel",
        :cost_source_id => 1,
        :cost_category_id => 1
      )
    ])
  end

  it "renders a list of costs" do
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
    assert_select "tr>td", :text => "Capital".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Operating".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Fuel".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Size".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Life".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Efficiency".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Valid In Year".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Valid For Quantity Of Fuel".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
