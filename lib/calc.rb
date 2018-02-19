##
# This class describes the functionality of the calculator application.
class Calculator
  attr_accessor :results
  OPERATOR_REGEX = "[+*\/^-]"
  INFIX_REGEX = "#{OPERATOR_REGEX}|[)(]|[0-9.]+"

  def initialize
    @results = []
  end

  ##
  # Function to evaluate a mathematic expression.
  # @param input [String] The string representation of the mathematic expression.
  def eval(input)
    input = @results.last + input if input[0].match(/#{OPERATOR_REGEX}/) && !@results.empty?
    infix = input.scan(/#{INFIX_REGEX}/)
    postfix = to_postfix(infix)
    result = evaluate_postfix(postfix)
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
    infix.map(&:strip).each do |curr|
      operand = curr.match(/[\d.]+/)
      operator = curr.match(/#{OPERATOR_REGEX}/)
      left_parenthesis = curr == '('
      right_parenthesis = curr == ')'
      if operand
        # add current number to postfix.
        # puts "number: #{curr.to_f}"
        postfix.push(curr.to_f)
      elsif operator
        # pop any operator of equal or higher precedence and add to postfix.
        # puts "operator: #{curr}"
        while !stack.empty? && stack.last != '(' && has_equal_or_higher_precedence(stack.last, curr) do
          postfix.push(stack.pop)
        end
      elsif right_parenthesis
        # pop all operators on top of the last left parenthesis.
        # puts "right: #{curr}"
        while !stack.empty? && stack.last != '(' do
          postfix.push(stack.pop)
        end
        raise "Malformatted expression. #{curr}; #{infix}" if stack.empty?
        # get rid of the parenthesis pair.
        stack.pop if stack.last == '('
      end
      # add the operator or the left parenthesis after stack work is done.
      stack.push(curr) if left_parenthesis || operator
      # puts "#{curr}; #{postfix}; #{stack}; #{operator}"
    end
    while !stack.empty? && stack.last.match(/#{OPERATOR_REGEX}/) do
      postfix.push(stack.pop)
    end
    raise "Malformatted expression. #{infix}" if !stack.empty?
    return postfix
  end

  ##
  # Function to evaluate a postfix expression.
  # @param postfix [Array] The postfix array to evaluate.
  # @return [Float] The result of the postfix array.
  def evaluate_postfix(postfix)
    stack = []
    postfix.each do |curr|
      if curr.is_a?(Float)
        stack.push(curr)
      else
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
        # puts "#{first} #{curr} #{second} = #{stack.last}"
      end
      # puts "#{stack}"
    end
    return stack.last
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
