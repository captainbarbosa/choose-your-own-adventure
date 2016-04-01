require_relative "test_helper"
require_relative '../lib/adventure'

class StepTest < Minitest::Test
  def test_step_can_be_created
    step = Adventure::Step.create(name: "Go to the moon", start: false, end: false, text: "Turns out, its not made out of cheese")

    assert_equal true, step.valid?
  end
end
