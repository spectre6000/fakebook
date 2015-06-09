class FriendshipsController < ApplicationController
  
  def create
    @friendship = current_user.friendships.build(:friend_id => params[:friend_id], :user_id => current_user.id)
    if @friendship.save
      flash[:notice] = "Added friend."
      redirect_to root_url
    else
      flash[:notice] = "Unable to add friend."
      redirect_to root_url
    end
  end

  def destroy
    user = params[:id]
    @friendship = current_user.friendships.find_by(friend_id: user)
    @friendship.destroy
    flash[:notice] = "Removed friendship."
    redirect_to root_url
  end

end