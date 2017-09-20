json.extract! post, :id, :user_id, :body, :title, :postable_type, :postable_id, :status, :created_at, :updated_at
json.user @post.user, partial: 'users/user', as: :user
json.postable @post.postable, partial: "#{@post.postable_type.downcase.pluralize}/#{@post.postable_type.downcase}", as: @post.postable_type.downcase.to_sym

json.url post_url(post, format: :json)
