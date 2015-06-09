class UsersController < ApplicationController

  before_filter :authenticate_user!

  def index 
    @users = User.all
  end

  def show
    @user = current_user
  end

  def edit

  end

  def friend(user)
    current_user.friendships.take(friend_id: user.id).accepted == true
  end

  def inverse_friend(user)
    current_user.inverse_friendships.take(user_id: user.id).accepted == true
  end

end