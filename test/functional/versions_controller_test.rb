require 'test_helper'

class VersionsControllerTest < ActionController::TestCase
  test "should get revert" do
    get :revert
    assert_response :success
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

end
