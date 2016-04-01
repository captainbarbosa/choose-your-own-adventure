require_relative "test_helper"

class AppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_declares_its_name
    response = get "/backend"
    assert response.ok?
    assert_equal "I am Groot!", response.body
  end

  def test_backend_echo_endpoint_will_return_exact_msg_back
    # hash is body of the request
    hash = { "name" => "bob" }
    response = post("/backend/echo", hash.to_json, { "CONTENT_TYPE" => "application/json" })

    assert response.ok?
    payload = JSON.parse(response.body)
    assert_equal(hash, payload)
  end

  def test_login_works_without_password
    hash = {}

    response = post("/login", hash.to_json, { "CONTENT_TYPE" => "application/json" })

    assert response.ok?
    assert "Welcome!", response.body.to_s
  end
end
