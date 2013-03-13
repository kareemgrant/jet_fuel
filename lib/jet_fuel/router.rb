require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/partial'
require 'haml'

module JetFuel
  database = YAML.load(File.open("database.yml"))

  ENV['DATABASE_URL'] ||= database["url"]

  class Router < Sinatra::Base
    register Sinatra::ActiveRecordExtension
    register Sinatra::Partial

    set :views, './lib/jet_fuel/views'
    set :sessions, true
    set :session_secret, 'super secret'
    set :database, ENV['DATABASE_URL']

    get '/' do
      @title = "JetFuel, the Url Shortner that doesn't suck"
      @url = Url.new
      haml :index
    end

    post '/urls' do

      url = Url.where(original: params[:original]).first_or_create
      if url
        redirect "/success/#{url.key}"
      else
        @message = "There was an issue: #{@url.errors.to_a.join(" ")}"
        haml :error
      end
    end

    get '/success/*' do |key|
      @url = Url.where("key = ?", params[:splat].join).first
      haml :success
    end

    post '/login' do
      clear_password = params[:password]
      user = User.find_by_username(params[:username])

      password_verifier = Digest::HMAC.new(user.salt, Digest::SHA1)
      submitted_password = password_verifier.hexdigest(clear_password)

      if user.crypted_password == submitted_password
        session[:user_id] = user.id
        redirect "/user/#{user.username}"
      else
        @errors = "Invalid username or password"
        haml :error
      end
    end

    get '/login' do
      haml :login
    end

    get '/logout' do
      session[:user_id] = nil
      redirect "/"
    end

    get '/kareem' do
      "Reemo"
    end

    post '/register' do
      clear_password = params[:password]
      salt = generate_salt
      password_signer = Digest::HMAC.new(salt,Digest::SHA1)
      crypted_password = password_signer.hexdigest(clear_password)
      user = User.new(username: params[:username], salt: salt, crypted_password: crypted_password)

      if user.save
        session[:user_id] = user.id
        redirect "/user/#{user.username}"
      else
        @errors = user.errors.to_a.join
        haml :error
      end
    end

    get '/register' do
      haml :register
    end

    get '/user/:username' do |username|
      @user = User.find_by_username(username)

      if current_user == @user
        haml :user
      else
        @errors = "you are not authorized to view this page"
        haml :error
      end

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

      def current_user
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
      end

      def generate_salt
        Array.new(32){rand(36).to_s(36)}.join
      end

    end

  end
end