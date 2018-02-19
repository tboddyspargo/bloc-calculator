# Bloculator
This is a command-line calculator application written in Ruby. It uses the postfix notation method to perform mathematic operations in the appropriate order even when provided complex expressions involving parenthesis, addition, subtraction, multiplication, division, and exponents.

# Usage
To use the calculator, simply 'require' it in your ruby console/application and then instantiate a Calculator instance. You can then call the 'eval' method on your calculator instance and pass it a mathematic expression you would like to evaluate. The calculator even remembers your previous results. If you would like to use your previous result in a new expression, simply begin your next expression with the operator you'd like to use.

```ruby
2.4.0 > require './calc.rb'
2.4.0 > my_calc = Calculator.new
2.4.0 > my_calc.eval("(62+1)/9")
2.4.0 > 7.0
2.4.0 > my_calc.eval("+14")
2.4.0 > 21.0
```
