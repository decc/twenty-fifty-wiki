require "spec_helper"

describe CostSourcesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/cost_sources" }.should route_to(:controller => "cost_sources", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/cost_sources/new" }.should route_to(:controller => "cost_sources", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/cost_sources/1" }.should route_to(:controller => "cost_sources", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/cost_sources/1/edit" }.should route_to(:controller => "cost_sources", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/cost_sources" }.should route_to(:controller => "cost_sources", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/cost_sources/1" }.should route_to(:controller => "cost_sources", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/cost_sources/1" }.should route_to(:controller => "cost_sources", :action => "destroy", :id => "1")
    end

  end
end
