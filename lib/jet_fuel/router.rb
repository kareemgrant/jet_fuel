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
      @url = Url.new
      haml :index, :layout => :layout
    end

    get '/hello/:name' do |n|
      "Hello #{n}!"
    end

    post '/urls' do
      key = generate_key
      @url = Url.new(original: params[:original], key: key)
      if @url.save
        redirect "/success/#{@url.key}"
      else
        @message = "There was an issue: #{@url.errors.to_a.join(" ")}"
        haml :error
      end
    end

    get '/success/*' do |key|
      @url = Url.where("key = ?", params[:splat].join).first
      haml :success
    end

    get '/*' do
      # add regex to provide more precise matching
      if @url = Url.where("key = ?", params[:splat].join).first
        redirect "http://#{@url.original}"
      else
        raise Sinatra::NotFound
      end
    end


    helpers do

      def generate_key
        "re.emo/#{Array.new(5){rand(36).to_s(36)}.join}"
      end

    end

  end
end