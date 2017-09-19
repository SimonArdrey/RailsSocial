class Post < ApplicationRecord
  STATUS_OPTIONS = {
    draft: "draft",
    published: "published",
    blocked: "blocked"
  }
  # Author
  belongs_to :user

  # Owner, User or Group
  belongs_to :postable, polymorphic: true

  enum status: STATUS_OPTIONS

  validates :user, presence: true
  validates :postable, presence: true
  validates :postable_type, presence: true
  validates :body, presence: true
  validates :status, presence: true, :inclusion => {
    in: statuses.keys,
    message: "%{value} is not a valid Post status"
  }

  after_initialize :set_defaults, unless: :persisted?
  after_initialize :corrections

  def set_defaults
    self.status = "draft"
  end

  def corrections
    # status == :draft if status == nil
  end
end
