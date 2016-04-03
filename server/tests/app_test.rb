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

  def test_new_adventure_endpoint_with_token
    # Retrieve login token to use in the second POST request
    init_hash = {}
    login_response = post("/login", init_hash.to_json, { "CONTENT_TYPE" => "application/json" })
    body = JSON.parse(login_response.body)

    # Add token to header for the following POST request
    header("AUTHORIZATION", body["token"])
    header("CONTENT_TYPE", "application/json")
    hash = { "adventure_name" => "A day at the beach" }
    new_adventure_response = post("/new_adventure", hash.to_json)
    new_adventure = JSON.parse(new_adventure_response.body)

    assert_equal true, new_adventure.has_key?("id")
  end

  def test_new_adventure_endpoint_with_invalid_token
    # Token is made up and does not match the one issued from POST /login
    header("AUTHORIZATION", 12345678)
    new_adventure_response = post("/new_adventure", hash.to_json)
    response = JSON.parse(new_adventure_response.body)

    assert_equal "User token invalid", response["msg"]
  end

  def test_new_step_endpoint
    # Issue unique login token
    init_hash = {}
    login_response = post("/login", init_hash.to_json, { "CONTENT_TYPE" => "application/json" })
    body = JSON.parse(login_response.body)

    # Make adventure, authorize with login token
    header("AUTHORIZATION", body["token"])
    header("CONTENT_TYPE", "application/json")
    hash = { "adventure_name" => "Winning the lottery" }
    new_adventure_response = post("/new_adventure", hash.to_json)
    new_adventure = JSON.parse(new_adventure_response.body)

    # Make step, authorize with login token
    header("AUTHORIZATION", body["token"])
    header("CONTENT_TYPE", "application/json")
    hash = { "name" => "Buy an island" }
    new_step_response = post("/new_step", hash.to_json)
    new_step = JSON.parse(new_step_response.body)

    assert_equal "Buy an island", new_step["name"]
    assert_equal new_adventure["id"], new_step["adventure_id"]
  end

  def test_new_step_endpoint_with_invalid_token
    # Token is made up and does not match the one issued from POST /login
    header("AUTHORIZATION", 12345678)
    new_step_response = post("/new_step", hash.to_json)
    response = JSON.parse(new_step_response.body)

    assert_equal "User token invalid", response["msg"]
  end

  def test_can_list_all_steps_belonging_to_an_adventure
    # Issue unique login token
    init_hash = {}
    login_response = post("/login", init_hash.to_json, { "CONTENT_TYPE" => "application/json" })
    body = JSON.parse(login_response.body)

    # Make adventure, authorize with login token
    header("AUTHORIZATION", body["token"])
    header("CONTENT_TYPE", "application/json")
    hash = { "adventure_name" => "Find a time machine" }
    new_adventure_response = post("/new_adventure", hash.to_json)
    new_adventure = JSON.parse(new_adventure_response.body)

    # Make first step, authorize with login token
    header("AUTHORIZATION", body["token"])
    header("CONTENT_TYPE", "application/json")
    hash = { "name" => "Go to the future" }
    first_step_response = post("/new_step", hash.to_json)
    first_step = JSON.parse(first_step_response.body)

    # Make second step, authorize with login token
    header("AUTHORIZATION", body["token"])
    header("CONTENT_TYPE", "application/json")
    hash = { "name" => "Go to the past" }
    second_step_response = post("/new_step", hash.to_json)
    second_step = JSON.parse(second_step_response.body)

    # Add above two steps to the adventure
    adventure_id = new_adventure["id"]
    response = get("/all_steps/#{adventure_id}")
    steps = JSON.parse(response.body)

    assert_equal 2, steps.length
  end

end
