class Post < ApplicationRecord
  # Author
  belongs_to :user

  # Owner, User or Group
  belongs_to :postable, polymorphic: true

  enum status: {
    draft: "draft",
    published: "published",
    blocked: "blocked"
  }

  validates :user, presence: true
  validates :owner, presence: true
  validates :body, presence: true
end
