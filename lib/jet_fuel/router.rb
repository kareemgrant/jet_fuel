require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/partial'
require 'haml'
require './config/environments'

module JetFuel
  # database = YAML.load(File.open("./config/database.yml"))

  # ENV['DATABASE_URL'] ||= database["development"]

  class Router < Sinatra::Base
    register Sinatra::ActiveRecordExtension
    register Sinatra::Partial

    set :views, './lib/jet_fuel/views'
    set :sessions, true
    set :session_secret, 'super secret'
    set :public_folder, 'public'

    get '/' do
      @title = "JetFuel, the Url Shortner that doesn't suck"
      @url = Url.new
      @popular_urls ||= Url.limit(10).order("visits DESC")
      @recent_urls ||= Url.limit(10).order("created_at DESC")
      haml :index
    end

    post '/urls' do
      original = check_uri_scheme(params[:original])
      url = Url.where(original: original).first_or_create
      if url.valid?
        redirect "/success/#{url.key}"
      else
        @errors = "There was an issue: #{url.errors.to_a.join(" ")}"
        haml :error
      end
    end

    get '/success/*' do |key|
      @url = Url.where("key = ?", params[:splat].join).first
      if @url
        haml :success
      else
        @errors = "You barking up the wrong tree bro!!!!"
        haml :error
      end
    end

    post '/login' do
      clear_password = params[:password]
      user = User.find_by_username(params[:username])

      if user
        password_verifier = Digest::HMAC.new(user.salt, Digest::SHA1)
        submitted_password = password_verifier.hexdigest(clear_password)

        if user.crypted_password == submitted_password
          session[:user_id] = user.id
          redirect "/profile/#{user.username}"
        else
          @errors = "Invalid username or password"
          haml :error
        end
      else
        @errors = "User account not found"
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
        redirect "/profile/#{user.username}"
      else
        @errors = user.errors.to_a.join
        haml :error
      end
    end

    get '/register' do
      haml :register
    end

    get '/profile/:username' do |username|
      @user = User.find_by_username(username)

      if current_user == @user
        haml :profile
      else
        @errors = "We have Bank Level Encrpytion fool! You are not authorized to view this page"
        haml :error
      end
    end

    get '/vanity_urls/:username' do |username|
      @user = User.find_by_username(username)

      if current_user == @user
        haml :vanity_urls
      else
        @errors = "We have Bank Level Encrpytion fool! You are not authorized to view this page"
        haml :error
      end
    end

    get '/dashboard/:username' do |username|

      @user = User.find_by_username(username)
      if current_user == @user
        @user_vanity_urls ||= @user.vanity_urls
        haml :dashboard
      else
        @errors = "I know what you did last summer, not cool man, not cool at all"
        haml :error
      end


    end

    post '/add_vanity_url' do

      base = params[:base]
      vanity_url = current_user.vanity_urls.create(base: base)

      if vanity_url.valid?
        redirect "/vanity_urls/#{current_user.username}"
      else
        @errors = vanity_url.errors.to_a.join
        haml :error
      end
    end

    get '/delete_vanity_url/:id' do
      @vanity_url = VanityUrl.find(params[:id].to_i)
      @title = "Confirm deletion of vanity url: #{@vanity_url.base}"
      haml :delete_vanity_url
    end

    post '/delete_vanity_url/:id' do
      vanity_url = VanityUrl.find(params[:id].to_i)
      vanity_url.destroy
      redirect "/vanity_urls/#{current_user.username}"
    end

    get '/jt.fl/*' do
      # add regex to provide more precise matching
      if @url = Url.where("key = ?", "jt.fl/#{params[:splat].join}").first
        Url.increment_counter(:visits, @url.id)
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

      def check_uri_scheme(url)
        u = URI::parse(url)
        if u.scheme.nil?
          formatted_url = "http://#{url}"
        else
          formatted_url = url
        end
      end
    end

  end
end