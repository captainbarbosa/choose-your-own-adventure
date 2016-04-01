require_relative "test_helper"
require '../lib/adventure'
require '../lib/adventure/step'

class AdventureTest < Minitest::Test
  def test_adventure_can_be_created
    adventure = Adventure::Adventure.create(adventure_name: "Wake up on a deserted island")

    assert_equal true, adventure.valid?
  end

  def test_adventure_has_many_steps
    adventure = Adventure::Adventure.create(adventure_name: "A trip to space")

    step_1 = Step.create(name: "Go to the moon", start: false, end: false, text: "Turns out, its not made out of cheese")
    step_2 = Step.create(name: "Go to the mars", start: false, end: false, text: "Why not grow some potatoes while you're there?")

    adventure.steps << step_1
    adventure.steps << step_2

    assert_equal [step_1, step_2], adventure.steps
  end
end
