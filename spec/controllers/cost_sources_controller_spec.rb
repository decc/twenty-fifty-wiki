require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by the Rails when you ran the scaffold generator.

describe CostSourcesController do

  def mock_cost_source(stubs={})
    @mock_cost_source ||= mock_model(CostSource, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all cost_sources as @cost_sources" do
      CostSource.stub(:all) { [mock_cost_source] }
      get :index
      assigns(:cost_sources).should eq([mock_cost_source])
    end
  end

  describe "GET show" do
    it "assigns the requested cost_source as @cost_source" do
      CostSource.stub(:find).with("37") { mock_cost_source }
      get :show, :id => "37"
      assigns(:cost_source).should be(mock_cost_source)
    end
  end

  describe "GET new" do
    it "assigns a new cost_source as @cost_source" do
      CostSource.stub(:new) { mock_cost_source }
      get :new
      assigns(:cost_source).should be(mock_cost_source)
    end
  end

  describe "GET edit" do
    it "assigns the requested cost_source as @cost_source" do
      CostSource.stub(:find).with("37") { mock_cost_source }
      get :edit, :id => "37"
      assigns(:cost_source).should be(mock_cost_source)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "assigns a newly created cost_source as @cost_source" do
        CostSource.stub(:new).with({'these' => 'params'}) { mock_cost_source(:save => true) }
        post :create, :cost_source => {'these' => 'params'}
        assigns(:cost_source).should be(mock_cost_source)
      end

      it "redirects to the created cost_source" do
        CostSource.stub(:new) { mock_cost_source(:save => true) }
        post :create, :cost_source => {}
        response.should redirect_to(cost_source_url(mock_cost_source))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved cost_source as @cost_source" do
        CostSource.stub(:new).with({'these' => 'params'}) { mock_cost_source(:save => false) }
        post :create, :cost_source => {'these' => 'params'}
        assigns(:cost_source).should be(mock_cost_source)
      end

      it "re-renders the 'new' template" do
        CostSource.stub(:new) { mock_cost_source(:save => false) }
        post :create, :cost_source => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested cost_source" do
        CostSource.stub(:find).with("37") { mock_cost_source }
        mock_cost_source.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :cost_source => {'these' => 'params'}
      end

      it "assigns the requested cost_source as @cost_source" do
        CostSource.stub(:find) { mock_cost_source(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:cost_source).should be(mock_cost_source)
      end

      it "redirects to the cost_source" do
        CostSource.stub(:find) { mock_cost_source(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(cost_source_url(mock_cost_source))
      end
    end

    describe "with invalid params" do
      it "assigns the cost_source as @cost_source" do
        CostSource.stub(:find) { mock_cost_source(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:cost_source).should be(mock_cost_source)
      end

      it "re-renders the 'edit' template" do
        CostSource.stub(:find) { mock_cost_source(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested cost_source" do
      CostSource.stub(:find).with("37") { mock_cost_source }
      mock_cost_source.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the cost_sources list" do
      CostSource.stub(:find) { mock_cost_source }
      delete :destroy, :id => "1"
      response.should redirect_to(cost_sources_url)
    end
  end

end
