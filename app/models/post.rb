class Post < ApplicationRecord
  paginates_per 10

  STATUS_OPTIONS = {
    draft: "draft",
    published: "published",
    blocked: "blocked"
  }

  KIND_OPTIONS = {
    basic: "basic",
    article: "blog",
    question: "question"
  }

  # Author
  belongs_to :user

  # Owner, User or Group
  belongs_to :postable, polymorphic: true

  belongs_to :parent, :class_name => 'Post', :optional => true
  has_many :replies, :class_name => 'Post', :foreign_key => 'parent_id'

  enum status: STATUS_OPTIONS
  enum kind: KIND_OPTIONS

  validates :user, presence: true
  validates :postable, presence: true
  validates :postable_type, presence: true
  validates :body, presence: true
  validates :status, presence: true, :inclusion => {
    in: statuses.keys,
    message: "%{value} is not a valid Post status"
  }

  after_initialize :set_defaults, unless: :persisted?

  def set_defaults
    self.status = "draft"
    self.kind = "basic"
  end

  def to_param
    "#{id.to_s}-#{[title.parameterize].join("-")}"
  end
end
