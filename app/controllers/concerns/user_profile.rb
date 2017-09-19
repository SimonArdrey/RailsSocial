module UserProfile
  extend ActiveSupport::Concern

  included do
    prepend_before_action :set_user
    before_action :set_profile_info
    layout "profile"
  end

  def set_user
    if params[:user_slug]
      @user = User.find_by_param(params[:user_slug])
    elsif params[:slug]
      @user = User.find_by_param(params[:slug])
    end
  end

  def set_profile_info
    return unless @user

    @user_post_count = @user.author_posts.count
  end
end
