require 'test_helper'

class FriendTest < ActiveSupport::TestCase
  
  def setup
    @friendship = Friend.new(friend_id: 1, friended_id: 2)
  end

  test "friend entity should be valid" do
    assert @friendship.valid?    
  end

  test "should require a friend_id" do 
    @friendship.friend_id = nil
    assert_not @friendship.valid?
  end

  test "should require a friended_id" do
    @friendship.friended_id = nil
    assert_not @friendship.valid?
  end

end
