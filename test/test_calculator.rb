require 'minitest/autorun'
require 'calc'

class CalculatorTest < Minitest::Test
  attr_accessor :calc

  def initialize(args)
    @calc = Calculator.new
    super(args)
  end

  def test_simple_addition
    assert_equal 12, @calc.eval('8+4')
  end

  def test_simple_subtraction
    assert_equal 4, @calc.eval('8-4')
  end

  def test_simple_multiplication
    assert_equal 32, @calc.eval('8*4')
  end

  def test_simple_division
    assert_equal 2, @calc.eval('8/4')
  end

  def test_simple_power
    assert_equal 4096, @calc.eval('8^4')
  end
end
