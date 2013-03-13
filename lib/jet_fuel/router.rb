require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/partial'
require 'haml'

module JetFuel
  database = YAML.load(File.open("database.yml"))

  ENV['DATABASE_URL'] ||= database["url"]

  class Router < Sinatra::Base
    set :views, './lib/jet_fuel/views'
    set :sessions, true
    set :database, ENV['DATABASE_URL']

    register Sinatra::ActiveRecordExtension
    register Sinatra::Partial

    get '/' do
      @title = "JetFuel, the Url Shortner that doesn't suck"
      @url = Url.new
      haml :index, :layout => :layout
    end

    post '/urls' do

      @url = Url.where(original: params[:original]).first_or_create
      if @url
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

    # post '/login' do

    # end

    get '/login' do
      haml :login
    end

    get '/kareem' do
      "Reemo"
    end

    post '/register' do
      clear_password = params[:password]
      salt = generate_salt
      password_signer = Digest::HMAC.new(salt,Digest::SHA1)
      crypted_password = password_signer.hexdigest(clear_password)
      @user = User.new(username: params[:username], salt: salt, crypted_password: crypted_password)

      if @user.save
        redirect "/user/#{@user.username}"
      else
        @errors = @user.errors.to_a.join
        haml :error
      end
    end

    get '/register' do
      haml :register
    end

    get '/user/:username' do |username|
      @user = User.find_by_username(username)
      haml :user
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

      def generate_salt
        Array.new(32){rand(36).to_s(36)}.join
      end

    end

  end
end