json.extract! user, :id, :slug, :first_name, :last_name, :created_at, :updated_at
json.display_name user.display_name

if user == current_user
  json.email user.email
end

json.url user_url(user, format: :json)
