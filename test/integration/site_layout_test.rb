require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:test1)
  end

  test "non-logged in users only see login page" do
    get root_path
    assert_response :redirect
    follow_redirect!
    assert_select "title", "Log in"
    get users_path
    assert_response :redirect
    follow_redirect!
    assert_select "title", "Log in"
    get user_path('1')
    assert_response :redirect
    follow_redirect!
    assert_select "title", "Log in"
    get edit_user_path('1')
    assert_response :redirect
    follow_redirect!
    assert_select "title", "Log in"
  end

  test "logged in users can see their pages" do
    get root_path
    assert_response :redirect
    follow_redirect!
    assert_select "title", "Log in"
    post user_session_path, 'user[email]' => @user.email, 'user[password]' =>  'password'
    follow_redirect!
    assert_response :success
    assert_select "title", "User Index"
    get users_path
    assert_response :success
    assert_select "title", "User Index"
    get user_path('1')
    assert_response :success
    assert_select "title", "#{@user.email}'s Console"
   end

end

