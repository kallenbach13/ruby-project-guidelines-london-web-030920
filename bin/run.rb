require_relative '../config/environment'
require_relative '../lib/CLI.rb'

system("clear")

cli = CommandLineInterface.new
cli.opening_greeting
1000000.times{cli.inner_greeting}