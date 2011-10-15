require 'bundler/setup'
require 'sinatra'
require 'model'

class App < Sinatra::Base

  helpers do
    alias_method :h, :escape_html
  end

  get '/' do
    'shippet'
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

end
