require 'spec_helper'

describe "costs/show.html.haml" do
  before(:each) do
    @cost = assign(:cost, stub_model(Cost,
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
    rendered.should match(/Capital/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Operating/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Fuel/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Size/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Life/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Efficiency/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Valid In Year/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Valid For Quantity Of Fuel/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
