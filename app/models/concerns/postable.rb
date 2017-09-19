module Postable
  extend ActiveSupport::Concern

  included do
    has_many :posts, as: :postable, class_name: "Post"
  end
end
