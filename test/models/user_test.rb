require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  test "fixture works" do
    @user1 = users(:test1)
    @user2 = users(:test2)
    assert @user1.valid?
    assert_not @user2.valid?
  end
  
end
