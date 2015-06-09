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
    if URI(request.referer).path == root_path
      @friendship = begin current_user.friendships.find_by(friend_id: params[:id]) rescue false end || begin current_user.inverse_friendships.find_by(user_id: params[:id]) rescue false end
    elsif URI(request.referer).path == friendships_path
      @friendship = current_user.inverse_friendships.find_by(user_id: params[:id])
    end
    @friendship.destroy
    flash[:notice] = "Removed friendship."
    if URI(request.referer).path == root_path
      redirect_to root_url
    elsif URI(request.referer).path == friendships_path
      redirect_to friendships_path
    end
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