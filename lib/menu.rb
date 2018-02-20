require_relative 'calc'

##
# This class defines the behavior of the command line for the calculator app.
class MenuController
  attr_accessor :calc

  def initialize
    @calc = Calculator.new
  end

  ##
  # This function will print to the console the high-level options for the command line calculator.
  def main_menu
    puts "Options:"
    puts "   'h' for expression history"
    puts "   'r' for past results"
    puts "   'c' to clear"
    puts "   'q' to exit"
    calc_menu
  end

  ##
  # This function will output the calculator prompt and read the user's input.
  def calc_menu
    puts "Enter an expression to evaluate:"
    input = gets.chomp

    case input
    when 'c'
      system "clear"
      main_menu
    when 'h'
      puts @calc.history
      calc_menu
    when 'r'
      puts @calc.results
      calc_menu
    when 'q' || 'exit'
      exit(0)
    else
      begin
        @calc.eval(input)
        puts "#{@calc.results.last}"
      rescue Exception => e
        puts "There was a problem evaluating the expression. Ensure it is properly constructed and try again."
        puts e.message
      end
      calc_menu
    end
  end

end
