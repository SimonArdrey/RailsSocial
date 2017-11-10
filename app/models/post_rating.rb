class PostRating < ApplicationRecord
  belongs_to :post
  belongs_to :user

  enum kind: {
    like: 0,
  }

  validates :kind, presence: true, :inclusion => {
    in: kinds.keys,
    message: "%{value} is not a valid PostRating kind id"
  }

  # def self.like_count(post)
  # end
  #
  # def self.like_count(post)
  # end
end
