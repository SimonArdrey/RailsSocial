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

    posts = Post
      .includes(:user, :postable, :parent, replies: [:user])
      .where(where)
      .order(created_at: :desc)
      .page(page)

    post_ids = posts.map { |post| post.id }

    like_counts = PostRating
      .where(kind: 'like')
      .group(:post_id)
      .count

    post_ids_the_viewer_likes = PostRating
      .where(post_id: post_ids, user_id: viewing_user.id, kind: 'like')
      .pluck(:post_id)

    # Update posts with prefeched info
    posts.each do |post|
      post.like_count = like_counts[post.id] || 0
      post.liked_by = (post_ids_the_viewer_likes.include?(post.id)) ? [viewing_user.id] : []
    end

    posts
  end
end
