class UsersController < ApplicationController
  include UserProfile

  def index
    @users = User.all
    render layout: "application"
  end

  def show
    @postable = @user
    @posts = BuildPostsFeed.run!({
      viewing_user: current_user,
      author_user: @user,
    })

    @post = Post.new
    @post.user = current_user
  end
end
