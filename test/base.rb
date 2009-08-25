require 'test/unit'
require File.join(File.dirname(__FILE__), '../lib/pedant')

Object.send :include, Pedant::Returns

class ReturnsTest < Test::Unit::TestCase
  def setup
    @foo = Foo.new
  end

  def test_returns
    assert_nothing_raised { @foo.should_succeed }
    assert_raise(Pedant::TypeError) { @foo.should_fail }
  end

  def test_user_guard
    assert_nothing_raised { @foo.small_int }
    assert_raise(Pedant::GuardError) { @foo.small_int_fail }
    assert_nothing_raised { @foo.guard_only }
  end

  def test_class_method
    assert_nothing_raised { Foo.should_succeed! }
  end

end


class Foo
  def should_fail
    :should_fail
  end
  def should_succeed
    :lolololol
  end
  returns(:should_fail, Integer, NilClass)
  returns(:should_succeed, Symbol)
  
  def small_int
    5
  end
  returns(:small_int, Integer) {|val| val < 10 }

  def small_int_fail
    100
  end
  returns(:small_int_fail, Integer) {|val| val < 10 }
  
  def guard_only
    'foo'
  end
  returns(:guard_only) {|val| val != 'bar' }
  
  class << self
    def should_succeed!
      :foo
    end
    returns(:should_succeed!, Symbol)
  end
end
