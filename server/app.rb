require 'bundler/setup'
require 'sinatra'
require 'model'
require 'omniauth'
require 'openssl'
require 'pp'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

class App < Sinatra::Base

  use Rack::Session::Cookie, :expire_after => 3600 * 24, :secret => "change me"

  use OmniAuth::Builder do
    provider :twitter, ENV["TW_TOKEN"], ENV["TW_SECRET"]
    provider :github, ENV["GH_TOKEN"], ENV["GH_SECRET"]
  end

  helpers do
    alias_method :h, :escape_html

    def current_user
      @user ||= Model::User.find_by_id session[:sid]
    end

    def login?
      current_user != nil
    end
  end

  get '/' do
    if login?
      "shippet user: #{current_user.name}"
    else
      "shippet"
    end
  end

  get '/snippet/create' do
    "create snippet"
    erb :create_snippet
  end

  post '/snippet/create' do
    snippet = Model::Snippet.create(params)
    p snippet
    "#{params[:code]} #{params[:mode]}"

  end

  get '/auth/:provider/callback' do |provider|
    user = Model::User.find_by_auth_or_create request.env["omniauth.auth"]
    session[:sid] = user.id
    redirect "/"
  end
end
