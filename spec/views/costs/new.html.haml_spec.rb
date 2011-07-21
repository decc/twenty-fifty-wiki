require 'spec_helper'

describe "costs/new.html.haml" do
  before(:each) do
    assign(:cost, stub_model(Cost,
      :label => "MyString",
      :content => "MyText",
      :user_id => 1,
      :deleted => false,
      :signed_off_by_id => 1,
      :capital => "MyString",
      :operating => "MyString",
      :fuel => "MyString",
      :size => "MyString",
      :life => "MyString",
      :efficiency => "MyString",
      :valid_in_year => "MyString",
      :valid_for_quantity_of_fuel => "MyString",
      :cost_source_id => 1,
      :cost_category_id => 1
    ).as_new_record)
  end

  it "renders new cost form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => costs_path, :method => "post" do
      assert_select "input#cost_label", :name => "cost[label]"
      assert_select "textarea#cost_content", :name => "cost[content]"
      assert_select "input#cost_user_id", :name => "cost[user_id]"
      assert_select "input#cost_deleted", :name => "cost[deleted]"
      assert_select "input#cost_signed_off_by_id", :name => "cost[signed_off_by_id]"
      assert_select "input#cost_capital", :name => "cost[capital]"
      assert_select "input#cost_operating", :name => "cost[operating]"
      assert_select "input#cost_fuel", :name => "cost[fuel]"
      assert_select "input#cost_size", :name => "cost[size]"
      assert_select "input#cost_life", :name => "cost[life]"
      assert_select "input#cost_efficiency", :name => "cost[efficiency]"
      assert_select "input#cost_valid_in_year", :name => "cost[valid_in_year]"
      assert_select "input#cost_valid_for_quantity_of_fuel", :name => "cost[valid_for_quantity_of_fuel]"
      assert_select "input#cost_cost_source_id", :name => "cost[cost_source_id]"
      assert_select "input#cost_cost_category_id", :name => "cost[cost_category_id]"
    end
  end
end
