class PostsController < ApplicationController

  before_action :user_signed_in?, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    @user = current_user
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = "Post created!"
      redirect_to @user
    else
      redirect_to @user
    end
  end

  def destroy
    @post.destroy
    flash[:success] = "Post deleted"
    redirect_to request.referrer || root_url
  end

  private

    def post_params
      params.require(:post).permit(:title, :content, :image)
    end

    def correct_user
      @post = current_user.posts.find_by(id: params[:id])
      redirect_to root_url if @post.nil?
    end

end