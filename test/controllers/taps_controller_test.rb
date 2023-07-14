require "test_helper"

class TapsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get taps_index_url
    assert_response :success
  end
end
