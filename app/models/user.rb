class User < ApplicationRecord
  include Postable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :author_posts, class_name: "Post"

  # validates_uniqueness_of :slug

  def gravatar_url(size=48)
    gravatar_id = Digest::MD5.hexdigest(email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
  end

  def display_name
    "#{first_name} #{last_name}"
  end

  def to_s
    display_name
  end

  def to_param
    # [name.parameterize].join("-")
    slug
  end

  def self.find_by_param(input)
    find_by_slug(input)
  end
end

=begin
Class User < ActiveRecord::Base
  has_many :invitees, class_name: 'User', foreign_key: :invited_by
  belongs_to :host, class_name: 'User', foreign_key: :invited_by
end
=end
