# Bloculator
This is a command-line calculator application written in Ruby. It uses the [postfix](https://en.wikipedia.org/wiki/Reverse_Polish_notation) notation method to perform mathematic operations in the appropriate order even when provided complex expressions involving parenthesis, addition, subtraction, multiplication, division, and exponents.

Bloculator makes use of `YARD` documentation gem to dynamically build documentation based on the formatted inline comments for the code.

Bloculator includes unit tests written with ruby's built-in `MiniTest` gem in order to facilitate maintainability, meet goals by using test driven development, and ensure the calculator remains functional even as it is enhanced with future features.

# Classes

## Calculator

This class encapsulates the calculator functionality.

| Method | Description |
| ------ | ----------- |
| eval   | The primary function for evaluating a mathematic expression, this function takes a string as an argument and will return the result of the mathematic operations.
| to_postfix | This function converts an 'infix' ordered array to a 'postfix' ordered array to facilitate executing from left to right.
| evaluate_postfix | This function evaluates a post fix array and returns the resulting value.
| has_equal_or_higher_precedence | This function determines whether the 'left' operator has an equal or higher precedence than the 'right' (passed as arguments) and returns a boolean. |

## MenuController

This class provides the 'UI' (such as it is) functionality for the command-line calculator.

| Method | Description |
| ------ | ----------- |
| main_menu | This function displays the high-level options a user has (read expression history, result history, clear the view, or exit). |
| calc_menu | This function displays the calculator prompt and reads the user's input. |


# Usage
To use the calculator, simply run the 'main.rb' ruby file.

```bash
$> ruby './lib/main.rb'
```
