require 'sinatra'
require 'rest-client'
require 'json'
require 'jwt'
require 'rake'
require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'
require 'pusher'
require './models/user'
require './models/phrase'
require './models/word'
require './auth'
require 'rubocop'
require 'dotenv'

Dotenv.load

class PublicRoutes < Sinatra::Base

  get '/' do
    send_file File.expand_path('index.html', settings.public_folder)
  end

  post '/users' do
    data = JSON.parse(request.body.read.to_s)
    @user = User.create(name: data['name'])
    @user.password = data['password']
    @user.save!
  end

  get '/phrases' do
    @phrases = Phrase.all.sort_by { |phrase| phrase.words.size }.reverse
    @phrases.to_json
  end

  get '/phrases/:id' do
    @phrase = Phrase.find(params['id'])
    @phrase.to_json
  end

  post '/login' do
    data = JSON.parse(request.body.read.to_s )
    @user = User.find_by(name: data['name'])
    if @user && @user.password == data['password']
      { token: token(data['name']) }.to_json
    end
  end

  get '/login/callback' do
    session_code = request.env['rack.request.query_hash']['code']
    result = RestClient.post(
              'https://github.com/login/oauth/access_token',
               {:client_id => ENV['GITHUB_ID'],
                :client_secret => ENV['GITHUB_SECRET'],
                :code => session_code},
                :accept => :json)
    access_token = JSON.parse(result)['access_token']
    auth_result = RestClient.get(
                    'https://api.github.com/user',
                    {:params => {:access_token => access_token},
                    :accept => :json})
    login = JSON.parse(auth_result)['login']
    @user = User.create(name: login, password: ' ')
    redirect '/login'
  end

  def token user_name
    JWT.encode payload(user_name), JWT_SECRET, 'HS256'
  end

  def payload user_name
    {
        exp: Time.now.to_i + 60 * 60,
        iat: Time.now.to_i,
        iss: JWT_ISSUER,
        user: {
          user_name: user_name
        }
    }
  end
end

