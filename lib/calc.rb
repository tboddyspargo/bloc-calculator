##
# This class describes the functionality of the calculator application.
class Calculator
  attr_accessor :history, :results
  # A regular expression string to match all acceptable operators.
  OPERATOR_REGEX = "[+*\/^-]"
  # A regular expression string to match all valid characters.
  INFIX_REGEX = "#{OPERATOR_REGEX}|[)(]|[0-9.]+"
  # A regular expression string to match all invalid characters.
  INVALID_REGEX = "[^0-9.)(+*\/^-]"

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
    input = @results.last.to_s + input if !@results.empty? && input[0].match(/#{OPERATOR_REGEX}/)
    raise "Malformatted expression - invalid characters: #{input}" if input.match(/#{INVALID_REGEX}/)
    infix = input.scan(/#{INFIX_REGEX}/)
    postfix = to_postfix(infix)
    result = evaluate_postfix(postfix)
    @history.push(input)
    @results.push(result)
    return result
  end

  private

  ##
  # Function to convert infix mathematic expression string to a postfix string.
  # @param infix [Array]  The infix array representation of the mathematic expression.
  # @return [Array] The postfix array representation of the mathematic expression.
  def to_postfix(infix)
    stack = []
    postfix = []
    infix.map(&:strip).reduce(nil) do |prev, curr|
      operand = curr.match(/[\d.]+/)
      operator = curr.match(/#{OPERATOR_REGEX}/)
      left_parenthesis = curr == '('
      right_parenthesis = curr == ')'
      if operand
        # raise error if number isn't valid format.
        raise "Malformatted expression - not a valid number: #{curr}" if curr.match(/[\d.]+/).nil? || curr.count('.') > 1
        # add current number to postfix.
        postfix.push(curr.to_f)
      elsif operator
        # raise error if multiple operators in a row.
        raise "Malformatted expression - consecutive operators: #{infix.join}" if !prev.nil? && prev.match(/#{OPERATOR_REGEX}/)
        # pop any operator of equal or higher precedence and add to postfix.
        while !stack.empty? && stack.last != '(' && has_equal_or_higher_precedence(stack.last, curr) do
          postfix.push(stack.pop)
        end
      elsif right_parenthesis
        # pop all operators on top of the last left parenthesis.
        while !stack.empty? && stack.last != '(' do
          postfix.push(stack.pop)
        end
        # raise error if right parenthesis was provided without left.
        raise "Malformatted expression - unmatched parenthesis: #{infix.join}" if stack.empty?
        # get rid of the parenthesis pair.
        stack.pop if stack.last == '('
      end
      # add the operator or the left parenthesis after stack work is done.
      stack.push(curr) if left_parenthesis || operator
      # set curr as the 'prev' value in the next 'reduce' loop
      curr
    end
    # push any remaining operators to postfix.
    while !stack.empty? && stack.last.match(/#{OPERATOR_REGEX}/) do
      postfix.push(stack.pop)
    end
    # raise error if any characters in stack are left unaccounted for.
    raise "Malformatted expression - unmatched parenthesis: #{infix.join}" if !stack.empty?
    return postfix
  end

  ##
  # Function to evaluate a postfix expression.
  # @param postfix [Array] The postfix array to evaluate.
  # @return [Float] The result of the postfix array.
  def evaluate_postfix(postfix)
    stack = []
    postfix.compact.each do |curr|
      if curr.is_a?(Float)
        stack.push(curr)
      elsif stack.count >= 2
        second = stack.pop
        first = stack.pop
        if curr == '+'
          stack.push(first + second)
        elsif curr == '-'
          stack.push(first - second)
        elsif curr == '*'
          stack.push(first * second)
        elsif curr == '/'
          stack.push(first / second)
        elsif curr == '^'
          stack.push(first ** second)
        else
          raise "Invalid character: #{curr}"
        end
      else
        raise "Invalid expression"
      end
    end
    result = stack.last
    return result == result.to_i ? result.to_i : result
  end

  ##
  # Function to compare the precedence of operators
  # @param left [String] the left operator
  # @param right [String] the right operator
  # @return [Boolean] whether or not the left operator has a higher precendence than the right.
  def has_equal_or_higher_precedence(left, right)
    add = ['-','+']
    mult = ['*','/']
    return false if add.include?(left) && mult.include?(right)
    return true
  end

end
