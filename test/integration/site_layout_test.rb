require 'test_helper'
include Devise::TestHelpers
class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:test1)
  end

  test "non-logged in users only see login page" do
    assert warden.authenticated?(:test1) == false
    get root_path
    assert_response :redirect
    follow_redirect!
    assert_template 'devise/sessions/new'
    get users_path
    assert_response :redirect
    follow_redirect!
    assert_template 'devise/sessions/new'
    get user_path('1')
    assert_response :redirect
    follow_redirect!
    assert_template 'devise/sessions/new'
    get edit_user_path('1')
    assert_response :redirect
    follow_redirect!
    assert_template 'devise/sessions/new'
    # assert warden.authenticated?(@user) == false
  end

  # test "logged in users can see their pages" do 
  #   sign_in @user
  #   assert warden.authenticated?(:user) == true
  #   get users_path
  #   assert_template "/users/index"
  # end

end