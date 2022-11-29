require "test_helper"

class ReportsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get reports_show_url

    assert_response :success
  end
end
