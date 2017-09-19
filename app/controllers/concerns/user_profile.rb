module UserProfile
  extend ActiveSupport::Concern

  included do
    prepend_before_action :set_user
    layout "profile"
  end

  def set_user
    if params[:user_slug]
      @user = User.find_by_slug(params[:user_slug])
    elsif params[:slug]
      @user = User.find_by_slug(params[:slug])
    end
  end
end
