# This is the global configuration file of the SimpleCov gem.
# More on: https://github.com/colszowka/simplecov#configuring-simplecov

require 'simplecov'
require 'simplecov-console'
require 'simplecov-json'

SimpleCov.start 'rails' do
  add_filter '/spec/'
  add_filter '/config/'
  formatter SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::Console,
    SimpleCov::Formatter::JSONFormatter
  ]
end
