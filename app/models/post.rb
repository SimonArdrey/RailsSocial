class Post < ApplicationRecord
  paginates_per 10

  STATUS_OPTIONS = {
    draft: 0,
    published: 1,
    blocked: 2
  }

  KIND_OPTIONS = {
    basic: 0,
    article: 1,
    question: 2
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
    message: "%{value} is not a valid Post status id"
  }

  after_initialize :set_defaults, unless: :persisted?

  def status=(value)
    write_attribute :status, value.to_i
  end

  def set_defaults
    # I am pretty sure this is wrong
    self.status = "draft"
    self.kind = "basic"
  end

  def to_param
    title.empty? ? id : "#{id.to_s}-#{[title.parameterize].join("-")}"
  end
end
