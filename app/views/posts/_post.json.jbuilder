json.extract! post, :id, :user_id, :body, :title, :owner_id, :owner_type, :is_published, :created_at, :updated_at
json.url post_url(post, format: :json)
