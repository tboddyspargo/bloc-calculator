##
# This class describes the functionality of the calculator application.
class Calculator
  attr_accessor :history, :results
  # An array of acceptable precedence 3 operators
  PRECEDENCE_3 = ["^"]
  # An array of acceptable precedence 2 operators
  PRECEDENCE_2 = ["*","/","÷"]
  # An array of acceptable precedence 1 operators
  PRECEDENCE_1 = ["+","-"]
  # An array of all acceptable operators. Prececence 1 is last because 'minus' must be last in a regular expression bracket group.
  OPERATORS = PRECEDENCE_3+PRECEDENCE_2+PRECEDENCE_1
  # A regular expression string to match all operators (and whitespace).
  OPERATOR_STRING = "[\s#{OPERATORS.join}]"
  # A regular expression string to match all numbers.
  NUM_STRING = "-?[0-9.]+"
  # A regular expression to match all numbers (include negative).
  NUM_REGEX = /#{NUM_STRING}/
  # A regular expression to match all valid characters.
  INFIX_REGEX = /#{"[)(]|(?<=^|#{OPERATOR_STRING})#{NUM_STRING}|#{OPERATOR_STRING}|#{NUM_STRING}"}/
  # A regular expression to match all invalid characters.
  INVALID_REGEX = /#{"[^0-9.)(\s#{OPERATORS.join}]"}/

  ##
  # initialize a calculator object.
  def initialize
    @history = []
    @results = []
  end

  ##
  # Function to evaluate a mathematic expression.
  # @param input [String] The string representation of the mathematic expression.
  def eval(input)
    # If first character is an operator and there is a previous result, start with that value as an operand.
    input = @results.last.to_s + input if !@results.empty? && OPERATORS.include?(input[0])
    raise "Malformatted expression - invalid characters: #{input}" if input.match(INVALID_REGEX)
    infix = to_infix(input)
    postfix = to_postfix(infix)
    result = evaluate_postfix(postfix)
    @history.push(input)
    @results.push(result)
    return result
  end

  private

  ##
  # Function to convert infix string to infix array
  # @param str [String] The infix string representation of the mathematic expression.
  # @return [Array] The infix array representation of the mathematic expression.
  def to_infix(str)
    prev = nil
    result = str.scan(INFIX_REGEX).map do |curr|
      # raise error if number isn't valid format.
      raise "Malformatted expression - not a valid number: #{curr}" if !curr.match(NUM_REGEX).nil? &&  curr.count('.') > 1
      # raise error if multiple operators in a row.
      raise "Malformatted expression - consecutive operators: #{infix.join}" if OPERATORS.include?(curr) && OPERATORS.include?(prev)
      prev = curr
      curr.strip
    end
    return result.compact
  end

  ##
  # Function to convert infix mathematic expression string to a postfix string.
  # @param infix [Array]  The infix array representation of the mathematic expression.
  # @return [Array] The postfix array representation of the mathematic expression.
  def to_postfix(infix)
    stack = []
    postfix = []
    prev = nil
    infix.each do |curr|
      is_operand = !curr.match(NUM_REGEX).nil?
      is_operator = OPERATORS.include?(curr)
      is_left_parenthesis = curr == '('
      is_right_parenthesis = curr == ')'

      if is_operand
        # add current number to postfix.
        postfix.push(curr.to_f)
      elsif is_right_parenthesis || is_operator
        # pop any operator of equal or higher precedence off stack and add to postfix until a left parenthesis is encountered.
        while !stack.empty? && stack.last != '(' && (is_right_parenthesis || has_equal_or_higher_precedence(stack.last, curr)) do
          postfix.push(stack.pop)
        end
        # get rid of the parenthesis pair or raise error if a pair is incomplete.
        raise "Malformatted expression - unmatched parenthesis: #{infix.join}" if is_right_parenthesis && stack.last != '('
        stack.pop if is_right_parenthesis && stack.last == '('
      end

      # add the operator or the left parenthesis to stack after postfix work is done.
      stack.push(curr) if is_left_parenthesis || is_operator
      prev = curr
    end # end infix loop

    # push any remaining operators to postfix.
    while !stack.empty? && OPERATORS.include?(stack.last) do postfix.push(stack.pop) end

    # raise error if any characters in stack are left unaccounted for.
    raise "Malformatted expression - leftover characters: #{infix.join} | #{stack}" if !stack.empty?
    return postfix.compact
  end

  ##
  # Function to evaluate a postfix expression.
  # @param postfix [Array] The postfix array to evaluate.
  # @return [Numeric] The result of the postfix array.
  def evaluate_postfix(postfix)
    stack = []
    postfix.compact.each do |curr|
      if curr.is_a?(Float)
        stack.push(curr)
      elsif stack.count >= 2
        first, second = stack.pop(2)
        case curr
        when '+' then stack.push(first + second)
        when '-' then stack.push(first - second)
        when '*' then stack.push(first * second)
        when '/' then stack.push(first / second)
        when '÷' then stack.push(first / second)
        when '^' then stack.push(first ** second)
        else raise "Invalid element: #{curr}"
        end
      else
        raise "Invalid expression"
      end
    end
    # default result is 0, unless a result was calculated.
    result = stack.empty? ? 0 : stack.last
    # Convert result to int if float == int
    return result == result.to_i ? result.to_i : result
  end

  ##
  # Function to compare the precedence of operators
  # @param left [String] the left operator
  # @param right [String] the right operator
  # @return [Boolean] whether or not the left operator has a higher precendence than the right.
  def has_equal_or_higher_precedence(left, right)
    ops = [PRECEDENCE_1.join, PRECEDENCE_2.join, PRECEDENCE_3.join]
    precedence_left, precedence_right, index = [-1, -1, -1]
    ops.each do |o|
      index += 1
      precedence_left = index if o.include?(left)
      precedence_right = index if o.include?(right)
    end
    raise "Invalid operator: #{left}" if precedence_left == -1
    raise "Invalid operator: #{right}" if precedence_right == -1
    return false if precedence_left < precedence_right
    return true
  end

end
