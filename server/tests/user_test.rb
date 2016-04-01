require_relative "test_helper"
require_relative '../lib/adventure'

class UserTest < Minitest::Test
  def test_user_can_be_created_with_a_random_token
    number = SecureRandom.hex
    user = Adventure::User.create(token: number)

    assert_equal number, user.token
  end

  def test_user_can_have_many_adventures
    user = Adventure::User.create(token: SecureRandom.hex)

    adventure_1 = Adventure::Adventure.create(adventure_name: "Run for president")
    adventure_2 = Adventure::Adventure.create(adventure_name: "Become a hermit")

    user.adventures << adventure_1
    user.adventures << adventure_2
  end
end
