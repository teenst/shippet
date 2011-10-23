require 'bundler/setup'
require 'sinatra'
require 'model'
require 'json'
require 'bson'

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
    ""
  end

  post '/snippet/delete' do
    snippet_id = BSON::ObjectId.from_string params[:snippet_id]
    Model::Snippet.remove snippet_id
    "delete snipet #{params[:snippet_id]}"
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
