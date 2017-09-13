class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :posts, as: :postable, class_name: "Post"
  has_many :author_posts, class_name: "Post"

  def gravatar_url(size=48)
    gravatar_id = Digest::MD5.hexdigest(email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
  end
end

=begin
Class User < ActiveRecord::Base
  has_many :invitees, class_name: 'User', foreign_key: :invited_by
  belongs_to :host, class_name: 'User', foreign_key: :invited_by
end
=end
