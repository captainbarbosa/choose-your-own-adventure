ENV["RACK_ENV"] ||= 'development'

require "rubygems"
require "bundler/setup"
require "sinatra"
require "json"
require "pry"

require_relative "lib/adventure"

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
  {token: token}.to_json
end
