require_relative "test_helper"
require_relative '../lib/adventure'

class AppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_can_get_login_token
    hash = {}
    response = post("/login", hash.to_json, { "CONTENT_TYPE" => "application/json" })
    assert response.ok?

    response = JSON.parse(response.body)
    assert_equal response.has_key?("token"), true
  end

  def test_endpoints_will_not_work_with_invalid_token
    # Occurs if login token does not match the one issued from POST /login
    header("AUTHORIZATION", 12345678)
    new_adventure_response = post("/new_adventure", hash.to_json)
    response = JSON.parse(new_adventure_response.body)

    assert_equal "User token invalid", response["msg"]
  end

  def test_new_adventure_endpoint
    # Get login token
    init_hash = {}
    login_response = post("/login", init_hash.to_json, { "CONTENT_TYPE" => "application/json" })
    body = JSON.parse(login_response.body)

    # Add token to header & create a new adventure
    header("AUTHORIZATION", body["token"])
    header("CONTENT_TYPE", "application/json")
    hash = { "adventure_name" => "A day at the beach" }
    new_adventure_response = post("/new_adventure", hash.to_json)
    new_adventure = JSON.parse(new_adventure_response.body)

    assert_equal true, new_adventure.has_key?("id")
  end

  def test_new_step_endpoint
    # Get login token
    init_hash = {}
    login_response = post("/login", init_hash.to_json, { "CONTENT_TYPE" => "application/json" })
    body = JSON.parse(login_response.body)

    # Add token to header & create a new adventure
    header("AUTHORIZATION", body["token"])
    header("CONTENT_TYPE", "application/json")
    hash = { "adventure_name" => "Winning the lottery" }
    new_adventure_response = post("/new_adventure", hash.to_json)
    new_adventure = JSON.parse(new_adventure_response.body)

    # Add token to header & create a new step
    header("AUTHORIZATION", body["token"])
    header("CONTENT_TYPE", "application/json")
    hash = { "name" => "Buy an island" }
    new_step_response = post("/new_step", hash.to_json)
    new_step = JSON.parse(new_step_response.body)

    assert_equal "Buy an island", new_step["name"]
    assert_equal new_adventure["id"], new_step["adventure_id"]
  end

  def test_can_list_all_steps_belonging_to_an_adventure
    # Get login token
    init_hash = {}
    login_response = post("/login", init_hash.to_json, { "CONTENT_TYPE" => "application/json" })
    body = JSON.parse(login_response.body)

    # Add token to header & create a new adventure
    header("AUTHORIZATION", body["token"])
    header("CONTENT_TYPE", "application/json")
    hash = { "adventure_name" => "Find a time machine" }
    new_adventure_response = post("/new_adventure", hash.to_json)
    new_adventure = JSON.parse(new_adventure_response.body)

    # Add token to header & create a new first step
    header("AUTHORIZATION", body["token"])
    header("CONTENT_TYPE", "application/json")
    hash = { "name" => "Go to the future" }
    first_step_response = post("/new_step", hash.to_json)
    first_step = JSON.parse(first_step_response.body)

    # Add token to header & create a new second step
    header("AUTHORIZATION", body["token"])
    header("CONTENT_TYPE", "application/json")
    hash = { "name" => "Go to the past" }
    second_step_response = post("/new_step", hash.to_json)
    second_step = JSON.parse(second_step_response.body)

    # List steps belonging to the adventure
    adventure_id = new_adventure["id"]
    response = get("/all_steps/#{adventure_id}")
    steps = JSON.parse(response.body)

    assert_equal 2, steps.length
  end

  def test_can_retrieve_users_adventures
    # Get login token
    init_hash = {}
    login_response = post("/login", init_hash.to_json, { "CONTENT_TYPE" => "application/json" })
    body = JSON.parse(login_response.body)

    # Add token to header & create a first new adventure
    header("AUTHORIZATION", body["token"])
    header("CONTENT_TYPE", "application/json")
    hash = { "adventure_name" => "Go to an all-you-can-eat buffet" }
    first_adventure_response = post("/new_adventure", hash.to_json)
    first_adventure = JSON.parse(first_adventure_response.body)

    # Add token to header & create a second new adventure
    header("AUTHORIZATION", body["token"])
    header("CONTENT_TYPE", "application/json")
    hash = { "adventure_name" => "Climb Mt. Everest" }
    second_adventure_response = post("/new_adventure", hash.to_json)
    second_adventure = JSON.parse(second_adventure_response.body)

    # List adventures belonging to user
    response = get("/adventures")
    adventures = JSON.parse(response.body)

    assert_equal 2, adventures.length
  end

  def test_adventure_can_be_updated
    # Get login token
    init_hash = {}
    login_response = post("/login", init_hash.to_json, { "CONTENT_TYPE" => "application/json" })
    body = JSON.parse(login_response.body)

    # Add token to header & create a new adventure
    header("AUTHORIZATION", body["token"])
    header("CONTENT_TYPE", "application/json")
    hash = { "adventure_name" => "My old adventure" }
    adventure_response = post("/new_adventure", hash.to_json)
    adventure = JSON.parse(adventure_response.body)
    adventure_id = adventure["id"]

    # Update adventure to have a new name
    header("AUTHORIZATION", body["token"])
    header("CONTENT_TYPE", "application/json")
    hash = { "adventure_name" => "My new adventure" }
    updated_adventure_response = patch("/adventure/#{adventure_id}", hash.to_json)

    assert_equal "true", updated_adventure_response.body
  end

  def test_step_can_be_updated
    # Get login token
    init_hash = {}
    login_response = post("/login", init_hash.to_json, { "CONTENT_TYPE" => "application/json" })
    body = JSON.parse(login_response.body)

    # Add token to header & create a new adventure
    header("AUTHORIZATION", body["token"])
    header("CONTENT_TYPE", "application/json")
    hash = { "adventure_name" => "Get abducted by aliens" }
    adventure_response = post("/new_adventure", hash.to_json)
    adventure = JSON.parse(adventure_response.body)
    adventure_id = adventure["id"]

    # Add token to header & create a new step
    header("AUTHORIZATION", body["token"])
    header("CONTENT_TYPE", "application/json")
    hash = { "name" => "Take the blue pill" }
    step_response = post("/new_step", hash.to_json)
    step = JSON.parse(step_response.body)
    step_id = step["id"]

    # Patch step to have a new name
    header("AUTHORIZATION", body["token"])
    header("CONTENT_TYPE", "application/json")
    hash = { "name" => "Take the red pill" }
    updated_step_response = patch("/adventure/#{adventure_id}/#{step_id}", hash.to_json)

    assert_equal "true", updated_step_response.body
  end

  def test_adventure_can_be_deleted
    # Get login token
    init_hash = {}
    login_response = post("/login", init_hash.to_json, { "CONTENT_TYPE" => "application/json" })
    body = JSON.parse(login_response.body)

    # Add token to header & create a new adventure
    header("AUTHORIZATION", body["token"])
    header("CONTENT_TYPE", "application/json")
    hash = { "adventure_name" => "Climb into a volcano" }
    adventure_response = post("/new_adventure", hash.to_json)
    adventure = JSON.parse(adventure_response.body)
    adventure_id = adventure["id"]

    # Delete adventure
    delete_adventure_response = delete("/adventure/#{adventure_id}")

    # List adventures belonging to user
    response = get("/adventures")
    adventures = JSON.parse(response.body)

    assert_equal [], adventures
  end

  def test_step_can_be_deleted
    # Get login token
    init_hash = {}
    login_response = post("/login", init_hash.to_json, { "CONTENT_TYPE" => "application/json" })
    body = JSON.parse(login_response.body)

    # Add token to header & create a new adventure
    header("AUTHORIZATION", body["token"])
    header("CONTENT_TYPE", "application/json")
    hash = { "adventure_name" => "Become a fish" }
    adventure_response = post("/new_adventure", hash.to_json)
    adventure = JSON.parse(adventure_response.body)
    adventure_id = adventure["id"]

    # Add token to header & create a new step
    header("AUTHORIZATION", body["token"])
    header("CONTENT_TYPE", "application/json")
    hash = { "name" => "Get eaten by a shark" }
    step_response = post("/new_step", hash.to_json)
    step = JSON.parse(step_response.body)
    step_id = step["id"]


    # Delete step
    delete_step_response = delete("/adventure/#{adventure_id}/#{step_id}")

    # Get steps belonging to this adventure
    response = get("/all_steps/#{adventure_id}")
    steps = JSON.parse(response.body)

    assert_equal [], steps
  end
end
