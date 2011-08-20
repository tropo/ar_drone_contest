%w(rubygems awesome_print rest-client json sinatra tropo-webapi-ruby).each{|lib| require lib}

require './app.rb'
run Sinatra::Application