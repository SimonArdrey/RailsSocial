class UsersPostsController < PostsController
  layout "profile"

  def index
    @posts = @postable.posts.order(created_at: :desc).limit(20)
  end

  private

  def set_postable
    @postable = User.find_by_slug(params[:slug])
  end
end
