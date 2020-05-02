require 'test_helper'

class KombatsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get kombats_index_url
    assert_response :success
  end

end
