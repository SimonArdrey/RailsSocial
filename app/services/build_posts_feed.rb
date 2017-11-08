require 'active_interaction'

class BuildPostsFeed < ApplicationService
  object :viewing_user, class: User
  object :postable, class: User, default: nil
  object :author_user, class: User, default: nil
  array :kinds_of_posts, default: ["basic"]
  integer :page, default: 1

  def execute
    find_posts
  end

  private

  def find_posts
    where = {
      kind: kinds_of_posts,
      status: "draft"
    }

    if postable
      where[:postable] = postable
    end

    if author_user
      where[:user] = author_user
    end

    Post
      .includes(:user, :postable, :parent, replies: [:user])
      .where(where)
      .order(created_at: :desc)
      .page(page)
  end
end
