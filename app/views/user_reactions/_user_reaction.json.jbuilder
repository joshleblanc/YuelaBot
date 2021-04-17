json.extract! user_reaction, :id, :created_at, :updated_at
json.url user_reaction_url(user_reaction, format: :json)
