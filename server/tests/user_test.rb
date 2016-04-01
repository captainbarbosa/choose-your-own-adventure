require_relative "test_helper"
require '../lib/user'

class UserTest < Minitest::Test
  def test_user_has_random_token
    number = SecureRandom.hex
    user = User.create(token: number)

    assert_equal number, user.token
  end

  def test_token_can_be_read_from_user

  end
end
