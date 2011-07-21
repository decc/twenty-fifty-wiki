require 'spec_helper'

describe "cost_categories/new.html.haml" do
  before(:each) do
    assign(:cost_category, stub_model(CostCategory,
      :label => "MyString",
      :content => "MyText",
      :user_id => 1,
      :deleted => false,
      :signed_off_by_id => 1,
      :default_capital_unit => "MyString",
      :default_operating_unit => "MyString",
      :default_fuel_unit => "MyString"
    ).as_new_record)
  end

  it "renders new cost_category form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => cost_categories_path, :method => "post" do
      assert_select "input#cost_category_label", :name => "cost_category[label]"
      assert_select "textarea#cost_category_content", :name => "cost_category[content]"
      assert_select "input#cost_category_user_id", :name => "cost_category[user_id]"
      assert_select "input#cost_category_deleted", :name => "cost_category[deleted]"
      assert_select "input#cost_category_signed_off_by_id", :name => "cost_category[signed_off_by_id]"
      assert_select "input#cost_category_default_capital_unit", :name => "cost_category[default_capital_unit]"
      assert_select "input#cost_category_default_operating_unit", :name => "cost_category[default_operating_unit]"
      assert_select "input#cost_category_default_fuel_unit", :name => "cost_category[default_fuel_unit]"
    end
  end
end
