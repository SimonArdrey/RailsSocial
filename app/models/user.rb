class User < ApplicationRecord
  include Postable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :author_posts, class_name: "Post"
  before_validation :set_slug

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  validates :slug, presence: true
  validates_uniqueness_of :slug

  # attribute :first_name, :string

  def gravatar_url(size=48)
    gravatar_id = Digest::MD5.hexdigest(email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
  end

  def display_name
    "#{first_name} #{last_name}"
  end

  def type
    :basic
  end

  def to_s
    display_name
  end

  def to_param
    return slug unless slug.empty?
    id
  end

  def self.find_by_param(param)
    user = find_by_slug(param.downcase)

    if not user
      user = find(param.to_i)
    end

    user
  end

  private

  def set_slug
    # Guard clause, only update slug if names have changed.
    return unless (first_name_changed? or last_name_changed?)

    self.slug = "#{first_name.downcase}.#{last_name.downcase}"
    return unless User.where(slug: slug).exists?

    # Max out at 10 attempts
    10.times do
      self.slug = "#{first_name.downcase}.#{last_name.downcase}.#{SecureRandom.random_number(10)}"
      break unless User.where(slug: slug).exists?
    end

    # TODO: Handle case when loop completes. Low chance right now.
  end
end

=begin
Class User < ActiveRecord::Base
  has_many :invitees, class_name: 'User', foreign_key: :invited_by
  belongs_to :host, class_name: 'User', foreign_key: :invited_by
end
=end
