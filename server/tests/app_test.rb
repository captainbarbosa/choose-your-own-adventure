require_relative "test_helper"
require_relative '../lib/adventure'

class AppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  # def test_declares_its_name
  #   response = get "/backend"
  #   assert response.ok?
  #   assert_equal "I am Groot!", response.body
  # end

  def test_backend_echo_endpoint_will_return_exact_msg_back
    # hash is body of the request
    hash = { "name" => "bob" }
    response = post("/backend/echo", hash.to_json, { "CONTENT_TYPE" => "application/json" })
    assert response.ok?
    payload = JSON.parse(response.body)
    assert_equal(hash, payload)
  end

  def test_login_endpoint
    hash = {}
    response = post("/login", hash.to_json, { "CONTENT_TYPE" => "application/json" })
    assert response.ok?

    response = JSON.parse(response.body)
    assert_equal response.has_key?("token"), true
  end

  def test_new_adventure_endpoint # Doesnt work properly
    init_hash = {}
    get_response = post("/login", init_hash.to_json, { "CONTENT_TYPE" => "application/json" })
    body = JSON.parse(get_response.body)

    hash = { "adventure_name" => "A day at the beach" }
    # Need to pass this POST request with a token in header
    post_response = post("/new_adventure", hash.to_json, { "CONTENT_TYPE" => "application/json" })
    post_response.headers["HTTP_AUTHORIZATION"] = body["token"]
    binding.pry
  end
end
