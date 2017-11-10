class Post < ApplicationRecord
  paginates_per 10

  # Author
  belongs_to :user

  # Owner, User or Group
  belongs_to :postable, polymorphic: true

  belongs_to :parent, :class_name => 'Post', :optional => true
  has_many :replies, :class_name => 'Post', :foreign_key => 'parent_id'
  has_many :post_ratings

  enum status: {
    draft: 0,
    published: 1,
    blocked: 2
  }

  enum kind: {
    basic: 0,
    article: 1,
    question: 2
  }

  validates :user, presence: true
  validates :postable, presence: true
  validates :postable_type, presence: true
  validates :body, presence: true
  validates :status, presence: true, :inclusion => {
    in: statuses.keys,
    message: "%{value} is not a valid Post status id"
  }

  validates :kind, presence: true, :inclusion => {
    in: kinds.keys,
    message: "%{value} is not a valid Post kind id"
  }

  # Fixes ActiveAdmin enum issue. ActiveAdmin sets dropdown id as a string
  def status=(value)
    write_attribute :status, value.to_i
  end

  def to_param
    if title and !title.empty?
      "#{id.to_s}-#{[title.parameterize].join("-")}"
    else
      id
    end
  end

  def like_count
    @like_count ? @like_count : PostRating.where(post: self, kind: 'like').count
  end

  def like_count=(count)
    @like_count = count
  end

  def liked_by?(user)
    if @liked_by_ids
      @liked_by_ids.include?(user.id)
    else
      is_liked = PostRating.where(post: self, user: user, kind: 'like').exists?
      @liked_by_ids = is_liked ? [user.id] : nil
      is_liked
    end
  end

  def liked_by=(ids)
    @liked_by_ids = ids
  end
end
