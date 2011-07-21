require "spec_helper"

describe CostCategoriesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/cost_categories" }.should route_to(:controller => "cost_categories", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/cost_categories/new" }.should route_to(:controller => "cost_categories", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/cost_categories/1" }.should route_to(:controller => "cost_categories", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/cost_categories/1/edit" }.should route_to(:controller => "cost_categories", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/cost_categories" }.should route_to(:controller => "cost_categories", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/cost_categories/1" }.should route_to(:controller => "cost_categories", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/cost_categories/1" }.should route_to(:controller => "cost_categories", :action => "destroy", :id => "1")
    end

  end
end
