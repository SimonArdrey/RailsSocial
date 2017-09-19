class UsersPostsController < PostsController
  include UserProfile

  private

  def set_postable
    @postable = @user
  end
end
