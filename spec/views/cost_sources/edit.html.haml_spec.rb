require 'spec_helper'

describe "cost_sources/edit.html.haml" do
  before(:each) do
    @cost_source = assign(:cost_source, stub_model(CostSource,
      :label => "MyString",
      :content => "MyText",
      :user_id => 1,
      :deleted => false,
      :signed_off_by_id => 1
    ))
  end

  it "renders the edit cost_source form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => cost_sources_path(@cost_source), :method => "post" do
      assert_select "input#cost_source_label", :name => "cost_source[label]"
      assert_select "textarea#cost_source_content", :name => "cost_source[content]"
      assert_select "input#cost_source_user_id", :name => "cost_source[user_id]"
      assert_select "input#cost_source_deleted", :name => "cost_source[deleted]"
      assert_select "input#cost_source_signed_off_by_id", :name => "cost_source[signed_off_by_id]"
    end
  end
end
