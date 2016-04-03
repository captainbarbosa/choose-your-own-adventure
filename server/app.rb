ENV["RACK_ENV"] ||= 'development'

require "rubygems"
require "bundler/setup"
require "sinatra"
require "json"
require "pry"
require_relative 'lib/adventure'

## DATA IS SAVED TO PRODUCTION DB

set :static, true
set :public_folder, Proc.new { File.join(root, "..", "client") }

before do
  content_type "application/json"
end

get "/backend" do
  "I am Groot!"
end

post "/backend/echo" do
  # payload is whats being passed in
  # request is the entire HTTP request
  # body is the body of the HTTP request, .read literally reads that
  # .parse converts JSON to ruby hash

  payload = JSON.parse(request.body.read)
  payload.to_json
  #echoing back what the client sends
end

get "/backend/steps" do
  Step.all.to_json
end

post "/login" do
  token = SecureRandom.hex
  user = Adventure::User.create(token: token)
  {token: user.token}.to_json
end

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

get "/adventures" do
  client_token = request.env["HTTP_AUTHORIZATION"]
  user = Adventure::User.where(token: client_token).first

  if user != nil
    user.adventures.to_json
  else
     halt 401, {msg: "User token invalid"}.to_json
  end
end

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
