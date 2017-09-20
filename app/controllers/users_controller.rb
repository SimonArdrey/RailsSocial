class UsersController < ApplicationController
  include UserProfile

  def index
    @users = User.all
    render layout: "application"
  end

  def show
    @postable = @user
    @posts = @user.author_posts
      .includes(:postable, :user)
      .order(created_at: :desc)
      .limit(20)

    @post = Post.new
    @post.user = current_user
  end
end
