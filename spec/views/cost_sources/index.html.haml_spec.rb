require 'spec_helper'

describe "cost_sources/index.html.haml" do
  before(:each) do
    assign(:cost_sources, [
      stub_model(CostSource,
        :label => "Label",
        :content => "MyText",
        :user_id => 1,
        :deleted => false,
        :signed_off_by_id => 1
      ),
      stub_model(CostSource,
        :label => "Label",
        :content => "MyText",
        :user_id => 1,
        :deleted => false,
        :signed_off_by_id => 1
      )
    ])
  end

  it "renders a list of cost_sources" do
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
  end
end
