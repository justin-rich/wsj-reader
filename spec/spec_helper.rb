ENV["RACK_ENV"]="test"

require 'rubygems'
require 'bundler'
Bundler.setup(:default, :test)

require 'sinatra'

require 'init'
require 'rspec'
require 'rack'
require 'factories'

#require 'lib/configurator.rb'
#Settings = Configurator.load

Dir["app/**/*.rb"].each {|req| require req}

set :environment, :test

# def request
#   Rack::MockRequest.new(Sinatra::Application)
 # end

def app
  eval "Rack::Builder.new {( " + File.read(File.dirname(__FILE__) + '/../config.ru') + "\n )}"
end

RSpec.configure do |config|
  config.before(:all) do
    DataMapper.auto_migrate!
  end
end
