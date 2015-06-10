require 'test_helper'

class FriendLogicTest < ActionDispatch::IntegrationTest

  def setup
    @user1 = users(:test1)
    @user2 = users(:test2)
    @user3 = users(:test3)
  end

  test "friending works" do
    post user_session_path, 'user[email]' => @user1.email, 'user[password]' =>  'password' ## user1 signs in
    follow_redirect!
    assert_response :success
    assert_select "title", "User Index"
    assert_select "a[href='?']", false, '/friendships/2'                # 0 rejects
    assert_select "a[href='?']", false, '/friendships/3'
    assert_select "a[href='?']", false, '/friendships/4'
    assert_select "a[href=?]", '/friendships?friend_id=2'               # 3 add friends
    assert_select "a[href=?]", '/friendships?friend_id=3'
    assert_select "a[href=?]", '/friendships?friend_id=4'
    assert_select "p", {count: 0}, 'pending'                            # 0 pending
    post friendships_path, :friend_id => '2'                        ## user1 adds user2 as friend
    follow_redirect!
    assert_response :success
    assert_select "title", "User Index"
    assert_select "a[href='?']", false, '/friendships/2'                # 0 rejects
    assert_select "a[href='?']", false, '/friendships/3'
    assert_select "a[href='?']", false, '/friendships/4'
    assert_select "a[href='?']", false, '/friendships?friend_id=2'      # 2 add friends
    assert_select "a[href=?]", '/friendships?friend_id=3'
    assert_select "a[href=?]", '/friendships?friend_id=4'
    assert_select "p", {count: 1}, 'pending'                            # 1 pending
    assert Friendship.all.count == 1                                  # 1 friendship (u=1/f=2/a=f)
    post friendships_path, :friend_id => '3'                        ## user1 adds user3 as friend
    follow_redirect!
    assert_response :success
    assert_select "title", "User Index"
    assert_select "a[href='?']", false, '/friendships/2'                # 0 rejects
    assert_select "a[href='?']", false, '/friendships/3'
    assert_select "a[href='?']", false, '/friendships/4'
    assert_select "a[href='?']", false, '/friendships?friend_id=2'      # 1 add friend
    assert_select "a[href='?']", false, '/friendships?friend_id=3'
    assert_select "a[href=?]", '/friendships?friend_id=4'
    assert_select "p", {count: 2}, 'pending'                            # 2 pendings
    assert Friendship.all.count == 2                                  # 2 friendships (u=1/f=2/a=f, u=1/f=3/a=f)
    delete destroy_user_session_path                                ## user1 logs out
    follow_redirect!
    post user_session_path, 'user[email]' => @user2.email, 'user[password]' =>  'password' ## user2 logs in
    follow_redirect!
    assert_response :success
    assert_select "title", "User Index"
    assert_select "a[href='?']", false, '/friendships/1'                # 0 rejects
    assert_select "a[href='?']", false, '/friendships/3'
    assert_select "a[href='?']", false, '/friendships/4'
    assert_select "a[href='1']", false, '/friendships?friend_id=1'      # 2 adds
    assert_select "a[href=?]", '/friendships?friend_id=3'
    assert_select "a[href=?]", '/friendships?friend_id=4'
    assert_select "p", {count: 1}, 'pending'                            # 1 pending
    post friendships_path, :friend_id => '3'                        ## user2 adds user3
    assert Friendship.all.count == 3                                  # 3 friendships (u=1/f=2/a=f, u=1/f=3/a=f, u=2/f=3/a=f)
    follow_redirect!
    assert_response :success
    assert_select "title", "User Index"
    assert_select "a[href='?']", false, '/friendships/1'                # 0 deletes
    assert_select "a[href='?']", false, '/friendships/3'
    assert_select "a[href='?']", false, '/friendships/4'
    assert_select "a[href='?']", false, '/friendships?friend_id=1'      # 1 add
    assert_select "a[href='?']", false, '/friendships?friend_id=3'
    assert_select "a[href=?]", '/friendships?friend_id=4'
    assert_select "p", {count: 2}, 'pending'                            # 2 pending
    get friendships_path                                            ## Notifications
    assert_select "a[href=?]", '/friendships/1/edit'                    # 1 accept/reject set
    assert_select "a[href=?]", '/friendships/1'
    get edit_friendship_path('1')                                   ## user2 accepts user 1
    assert Friendship.all.count == 3                                  # 3 friendships (u=1/f=2/a=t, u=1/f=3/a=f, u=2/f=3/a=f)
    follow_redirect!
    assert_select "a[href='?']", false, '/friendships/1/edit'           # 0 accept/reject links
    assert_select "a[href='?']", false, '/friendships/1'
    get root_path                                                   ## home
    assert_response :success
    assert_select "title", "User Index"
    assert_select "a[href=?]", '/friendships/1'                         # 1 reject link
    assert_select "a[href='?']", false, '/friendships/3'
    assert_select "a[href='?']", false, '/friendships/4'
    assert_select "a[href='?']", false, '/friendships?friend_id=1'      # 1 add link
    assert_select "a[href='?']", false, '/friendships?friend_id=3'
    assert_select "a[href=?]", '/friendships?friend_id=4'
    assert_select "p", {count: 1}, 'pending'                            # 1 pending
    assert Friendship.all.count == 3                                  # 3 friendships (u=1/f=2/a=t, u=1/f=3/a=f, u=2/f=3/a=f)
    delete destroy_user_session_path                                ## user2 logs out
    follow_redirect!
    post user_session_path, 'user[email]' => @user3.email, 'user[password]' =>  'password' ## user3 logs in
    follow_redirect!
    assert_response :success
    assert_select "title", "User Index"
    assert_select "a[href='?']", false, '/friendships/2'                # 0 rejects
    assert_select "a[href='?']", false, '/friendships/1'
    assert_select "a[href='?']", false, '/friendships/4'
    assert_select "a[href='?']", false, '/friendships?friend_id=2'      # 1 add friends
    assert_select "a[href='?']", false, '/friendships?friend_id=3'
    assert_select "a[href=?]", '/friendships?friend_id=4'
    assert_select "p", {count: 2}, 'pending'                            # 2 pending
    assert Friendship.all.count == 3                                  # 3 friendships (u=1/f=2/a=t, u=1/f=3/a=f, u=2/f=3/a=f)
    get friendships_path                                            ## Notifications
    assert_select "a[href=?]", '/friendships/1/edit'                    # 2 accept/reject sets
    assert_select "a[href=?]", '/friendships/1'
    assert_select "a[href=?]", '/friendships/2/edit'
    assert_select "a[href=?]", '/friendships/2'
    get edit_friendship_path('1')                                   ## user3 accepts user 1
    assert Friendship.all.count == 3                                  # 3 friendships (u=1/f=2/a=t, u=1/f=3/a=t, u=2/f=3/a=f)
    follow_redirect!
    assert_select "a[href='?']", false, '/friendships/1/edit'           # 1 accept/reject links
    assert_select "a[href='?']", false, '/friendships/1'
    assert_select "a[href=?]", '/friendships/2/edit'
    assert_select "a[href=?]", '/friendships/2'
    delete '/friendships/2'                                         ## user3 rejects user2 from Notification (F-side reject Notification)
    assert Friendship.all.count == 2                                  # 2 friendships (u=1/f=2/a=t, u=1/f=3/a=t)
    assert_select "a[href='?']", false, '/friendships/1/edit'           # 0 accept/reject links
    assert_select "a[href='?']", false, '/friendships/1'
    assert_select "a[href='?']", false, '/friendships/2/edit'
    assert_select "a[href='?']", false, '/friendships/2'
    get root_path
    assert_select "title", "User Index"
    assert_select "a[href='?']", false, '/friendships/2'                # 1 rejects
    assert_select "a[href=?]", '/friendships/1'
    assert_select "a[href='?']", false, '/friendships/4'
    assert_select "a[href=?]", '/friendships?friend_id=2'               # 2 add friends
    assert_select "a[href='?']", false, '/friendships?friend_id=3'
    assert_select "a[href=?]", '/friendships?friend_id=4'
    assert_select "p", {count: 0}, 'pending'                            # 0 pending
    delete '/friendships/1'                                         ## user3 rejects user1 from Index (F-side reject Index)
    assert Friendship.all.count == 1                                  # 1 friendships (u=1/f=2/a=t)
    delete destroy_user_session_path                                ## user3 logs out
    follow_redirect!
    post user_session_path, 'user[email]' => @user1.email, 'user[password]' =>  'password' ## user1 logs in
    follow_redirect!
    assert_response :success
    assert_select "title", "User Index"
    assert_select "a[href='?']", false, '/friendships/3'                # 1 rejects
    assert_select "a[href=?]", '/friendships/2'
    assert_select "a[href='?']", false, '/friendships/4'
    assert_select "a[href=?]", '/friendships?friend_id=3'               # 2 add friends
    assert_select "a[href='?']", false, '/friendships?friend_id=2'
    assert_select "a[href=?]", '/friendships?friend_id=4'
    assert_select "p", {count: 0}, 'pending'                            # 0 pending
    delete '/friendships/2'                                         ## user1 rejects user2 from Index (U-side reject Index)
    assert Friendship.all.count == 0                                  # 0 friendships
  end

end