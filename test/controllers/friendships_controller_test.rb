require 'test_helper'

class FriendshipsControllerTest < ActionController::TestCase

  test "friending works" do
    get root_path
    assert_response :redirect
    follow_redirect!
    assert_select "title", "Log in"
    post user_session_path, 'user[email]' => @user.email, 'user[password]' =>  'password'
    follow_redirect!
    assert_response :success
    assert_select "title", "User Index"
  end

end
