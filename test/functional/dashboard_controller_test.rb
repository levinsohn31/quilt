require 'test_helper'

class DashboardControllerTest < ActionController::TestCase
  test "should get base" do
    get :base
    assert_response :success
  end

end
