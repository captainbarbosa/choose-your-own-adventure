ENV["RACK_ENV"] ||= 'development'

require "rubygems"
require "bundler/setup"
require "sinatra"
require "json"
require "pry"
require_relative 'lib/adventure'

## DATA IS SAVED TO PRODUCTION DB WHEN THIS FILE IS RUN

set :static, true
set :public_folder, Proc.new { File.join(root, "..", "client") }

before do
  content_type "application/json"
end

# Dispatch login token to client, assign to user
post "/login" do
  token = SecureRandom.hex
  user = Adventure::User.create(token: token)
  {token: user.token}.to_json
end

# Create a new adventure belonging to user
post "/new_adventure" do
  client_token = request.env["HTTP_AUTHORIZATION"]
  user = Adventure::User.where(token: client_token).first

  if user != nil
    body = JSON.parse(request.body.read)
    adventure = Adventure::Adventure.create(body)
    user.adventures << adventure
    adventure.to_json
  else
     halt 401, {msg: "User token invalid"}.to_json
  end
end

# List a single user's adventure
get "/adventure/:id" do
  client_token = request.env["HTTP_AUTHORIZATION"]
  user = Adventure::User.where(token: client_token).first

  if user != nil
    adventure = Adventure::Adventure.where(user_id: user.id).first
    adventure.to_json
  else
     halt 401, {msg: "User token invalid"}.to_json
  end
end

# List user's multiple adventures
get "/adventures" do
  client_token = request.env["HTTP_AUTHORIZATION"]
  user = Adventure::User.where(token: client_token).first

  if user != nil
    user.adventures.to_json
  else
     halt 401, {msg: "User token invalid"}.to_json
  end
end

# Update a user's adventure
patch "/adventure/:id" do
  client_token = request.env["HTTP_AUTHORIZATION"]
  user = Adventure::User.where(token: client_token).first

  if user != nil
    payload = JSON.parse(request.body.read)
    adventure = Adventure::Adventure.find(params["id"]).update(payload).to_json
  else
     halt 401, {msg: "User token invalid"}.to_json
  end
end

# Delete a user's adventure
delete "/adventure/:id" do
  client_token = request.env["HTTP_AUTHORIZATION"]
  user = Adventure::User.where(token: client_token).first

  if user != nil
    adventure = Adventure::Adventure.find(params["id"]).destroy
    adventure.to_json
  else
     halt 401, {msg: "User token invalid"}.to_json
  end
end

# Create a new step belonging to an adventure
post "/new_step" do
  client_token = request.env["HTTP_AUTHORIZATION"]
  user = Adventure::User.where(token: client_token).first

  if user != nil
    adventure = Adventure::Adventure.where(user_id: user.id).first
    body = JSON.parse(request.body.read)
    step = Adventure::Step.create(body)
    adventure.steps << step
    step.to_json
  else
     halt 401, {msg: "User token invalid"}.to_json
  end
end

# List a single step belonging to an adventure
get "/adventure/:id/:step_id" do
  client_token = request.env["HTTP_AUTHORIZATION"]
  user = Adventure::User.where(token: client_token).first

  if user != nil
    adventure = Adventure::Adventure.where(id: ":id").first
    step = Adventure::Step.find(params["step_id"])
    step.to_json
  else
     halt 401, {msg: "User token invalid"}.to_json
  end
end

# List multiple steps belonging to an adventure
get "/all_steps/:id" do
  client_token = request.env["HTTP_AUTHORIZATION"]
  user = Adventure::User.where(token: client_token).first

  if user != nil
    adventure = Adventure::Adventure.where(user_id: user.id).first
    adventure.steps.to_json
  else
     halt 401, {msg: "User token invalid"}.to_json
  end
end

# Update a step belonging to an adventure
patch "/adventure/:id/:step_id" do
  client_token = request.env["HTTP_AUTHORIZATION"]
  user = Adventure::User.where(token: client_token).first

  if user != nil
    payload = JSON.parse(request.body.read)
    adventure = Adventure::Adventure.where(id: ":id").first
    step = Adventure::Step.find(params["step_id"]).update(payload).to_json
  else
     halt 401, {msg: "User token invalid"}.to_json
  end
end

# Delete a step belonging to an adventure
delete "/adventure/:id/:step_id" do
  client_token = request.env["HTTP_AUTHORIZATION"]
  user = Adventure::User.where(token: client_token).first

  if user != nil
    adventure = Adventure::Adventure.where(id: ":id").first
    step = Adventure::Step.find(params["step_id"]).destroy
    step.to_json
  else
     halt 401, {msg: "User token invalid"}.to_json
  end
end
