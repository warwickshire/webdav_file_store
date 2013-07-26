require_relative '../test_helper'
require 'thing'

class ThingTest < ActiveSupport::TestCase

  def setup
    @thing = Thing.find(1)
  end

  def test_setup
    assert_equal 'Foo', @thing.name
  end
end
