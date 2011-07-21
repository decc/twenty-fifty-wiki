require 'spec_helper'

describe "cost_sources/show.html.haml" do
  before(:each) do
    @cost_source = assign(:cost_source, stub_model(CostSource,
      :label => "Label",
      :content => "MyText",
      :user_id => 1,
      :deleted => false,
      :signed_off_by_id => 1
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
  end
end
