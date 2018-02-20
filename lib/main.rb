#!/usr/bin/ruby
require_relative "menu"

# Main program logic
menu = MenuController.new

system "clear"

menu.main_menu
