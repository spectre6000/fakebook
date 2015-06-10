class FriendshipsController < ApplicationController
  
  def create
    @friendship = current_user.friendships.build(:friend_id => params[:friend_id], :user_id => current_user.id)
    if @friendship.save
      flash[:success] = "Added friend."
      redirect_to root_url
    else
      flash[:notice] = "Unable to add friend."
      redirect_to root_url
    end
  end

  def destroy
    @friendship = begin current_user.friendships.find_by(friend_id: params[:id]) rescue false end || begin current_user.inverse_friendships.find_by(user_id: params[:id]) rescue false end
    @friendship.destroy
    flash[:success] = "Removed friendship."
    redirect_to root_path
  end

  def index
    @pending = current_user.inverse_friendships.where(accepted: false)
  end

  def edit
    friend = current_user.inverse_friendships.find_by(user_id: params[:id])
    friend.update_attribute(:accepted, true)
    redirect_to friendships_path
  end

end