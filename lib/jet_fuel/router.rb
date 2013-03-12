require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/partial'
require 'haml'

module JetFuel
  database = YAML.load(File.open("database.yml"))

  ENV['DATABASE_URL'] ||= database["url"]

  class Router < Sinatra::Base
    set :views, './lib/jet_fuel/views'

    register Sinatra::ActiveRecordExtension
    register Sinatra::Partial
    set :database, ENV['DATABASE_URL']

    get '/' do
      @title = "JetFuel, the Url Shortner that doesn't suck"
      @message = "Welcome to Reemo's world!!!!"
      haml :index, :layout => :layout
    end

    get '/shorten_test' do
      "Yo pimping!!!"
    end

  end
end