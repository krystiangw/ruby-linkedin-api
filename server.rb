require "rubygems"
require "haml"
require "sinatra"
require "linkedin"
require 'json'

enable :sessions

helpers do
  def login?
    !session[:atoken].nil?
  end

  def profile
    linkedin_client.profile unless session[:atoken].nil?
  end

  def connections
    linkedin_client.connections unless session[:atoken].nil?
  end

  private
  def linkedin_client
    client = LinkedIn::Client.new(settings.api, settings.secret)
    client.authorize_from_access(session[:atoken], session[:asecret])
    client
  end

end

configure do
  # get your api keys at https://www.linkedin.com/secure/developer
  set :api, "75rgtmh80zyxog"
  set :secret, "ssQv20q9qEHahxBG"
end

get "/auth" do
  client = LinkedIn::Client.new(settings.api, settings.secret)
  request_token = client.request_token(:oauth_callback => "http://#{request.host}:#{request.port}/auth/callback")
  session[:rtoken] = request_token.token
  session[:rsecret] = request_token.secret

  redirect client.request_token.authorize_url
end

get "/auth/logout" do
   session[:atoken] = nil
   redirect "/"
end

get "/auth/callback" do
  client = LinkedIn::Client.new(settings.api, settings.secret)
  if session[:atoken].nil?
    pin = params[:oauth_verifier]
    atoken, asecret = client.authorize_from_request(session[:rtoken], session[:rsecret], pin)
    session[:atoken] = atoken
    session[:asecret] = asecret
  end
  redirect "/profile"
end

get "/profile" do
	begin
		search_hash = Hash[params.map{ |k, v| [k.to_sym, v] }]
	  	search = linkedin_client.profile(search_hash)
	  	data = search.to_json
	rescue LinkedIn::Errors::UnauthorizedError
		redirect "/auth"
	rescue Exception => e  
		return e.to_json
	end
	return data
end

get "/company" do
	begin
		search_hash = Hash[params.map{ |k, v| [k.to_sym, v] }]
  	search = linkedin_client.search(search_hash, type ='company')
  	data = search.to_json
	rescue LinkedIn::Errors::UnauthorizedError
		redirect "/auth"
	rescue Exception => e  
		return e.to_json
	end
	return data
end
