require_relative '../test_helper'
require_relative '../lib/foo'

class FooTest < Minitest::Test
  def test_sanity
    puts Foo
    foo = Foo.new
    assert_equal foo.to_s, "I am Foo Class Instance"
  end
end

