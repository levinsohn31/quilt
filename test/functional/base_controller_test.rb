require 'test_helper'

class BaseControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get tables" do
    get :tables
    assert_response :success
  end

  test "should get forms" do
    get :forms
    assert_response :success
  end

  test "should get buttons" do
    get :buttons
    assert_response :success
  end

  test "should get icons" do
    get :icons
    assert_response :success
  end

end
