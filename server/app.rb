require 'bundler/setup'
require 'sinatra'
require 'model'
require 'json'

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

  get '/snippet/client_test.json' do
    content_type :json
    JSON.unparse(
      mode:"text-mode",
      snippet: <<-EOF
#name: ${1:name}
#key: ${2:key}
#--
test $1 snippet
EOF
      )
  end

end
