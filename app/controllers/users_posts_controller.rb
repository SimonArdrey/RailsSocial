class UsersPostsController < PostsController
  include UserProfile

  def self.controller_path
    "posts" # change path from app/views/user_posts to app/views/posts
  end

  private

  def set_postable
    @postable = @user
  end
end
