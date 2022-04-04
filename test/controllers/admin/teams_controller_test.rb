require "test_helper"

class Admin::TeamsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_teams_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_teams_show_url
    assert_response :success
  end
end
