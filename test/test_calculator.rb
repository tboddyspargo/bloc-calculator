require 'minitest/autorun'
require 'calc'

##
# This class defines the tests for the calculator class.
class CalculatorTest < Minitest::Test
  attr_accessor :calc

  def initialize(args)
    @calc = Calculator.new
    super(args)
  end

  ###############
  # Valid input

  def test_empty
    assert @calc.eval('') == 0
  end

  def test_positive_singleton
    assert @calc.eval('8') == 8
  end

  def test_negative_singleton
    assert @calc.eval('-8') == -8
  end

  def test_missing_leading_zero
    assert @calc.eval(".5") == 0.5
  end

  def test_missing_trailing_zero
    assert @calc.eval("5.") == 5
  end

  def test_simple_addition
    assert @calc.eval('8+4') == 12
  end

  def test_negative_addition
    assert @calc.eval('8+-4') == 4
  end

  def test_simple_subtraction
    assert @calc.eval('8-4') == 4
  end

  def test_negative_subtraction
    assert @calc.eval('8--4') == 12
  end

  def test_simple_multiplication
    assert @calc.eval('8*4') == 32
  end

  def test_negative_multiplication
    assert @calc.eval('8*-4') == -32
  end

  def test_simple_division_1
    assert @calc.eval('8/4') == 2
  end

  def test_simple_division_2
    assert @calc.eval('8÷4') == 2
  end

  def test_negative_division
    assert @calc.eval('8/-4') == -2
  end

  def test_simple_power
    assert @calc.eval('8^4') == 4096
  end

  def test_negative_power
    assert @calc.eval('8^-4') == Rational(1, 4096).to_f
  end

  def test_parentheses
    assert @calc.eval('(8+4)/4') == 3
  end

  def test_multiple_parentheses
    assert @calc.eval('(8+4*(4-4))/4') == 2
  end

  def test_white_space
    assert @calc.eval('8 + -4') == 4
  end

  ###############
  # Invalid input

  def test_bad_number_format_1
    assert_raises { @calc.eval('8..3+2') }
  end

  def test_bad_number_format_2
    assert_raises { @calc.eval('8.3.+1') }
  end

  def test_consecutive_operators
    assert_raises { @calc.eval('6+*3') }
  end

  def test_invalid_characters
    assert_raises { @calc.eval('soja') }
  end

  def test_invalid_lonely_operator
    assert_raises { @calc.eval('+') }
  end

  def test_extra_left_parenthesis
    assert_raises { @calc.eval('2*((3-2)+5') }
  end

  def test_extra_right_parenthesis
    assert_raises { @calc.eval('2*(3-2))+5') }
  end

  ##########
  # Features

  def test_history
    @calc.eval('1+1')
    assert_instance_of Array, @calc.history
    assert @calc.history.count == 1
    assert @calc.history.last == '1+1'
  end

  def test_results
    @calc.eval('1+1')
    assert_instance_of Array, @calc.results
    assert @calc.results.count == 1
  end
end
