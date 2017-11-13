require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require './models'
require 'pry'

enable :sessions

# Database configuration
set :database, "sqlite3:development.sqlite3"

# helper methods
# define current user
def current_user
  @user ||= User.find_by_id(session[:user_id])
end

# authenticate current user
def authenticate_user
  redirect '/login' if current_user.nil?
end

def next_group_messages(num, messages)
  msgs = []

  for i in 0...num
    msg = messages[session[:from_num]]
    if(msg.nil?)
      session[:reached_last] = true
      break
    end


    msgs << msg

    session[:from_num] += 1
  end

  msgs
end

get '/login' do
  session[:login]=true
  erb :login
end

get '/logout' do
  binding.pry
  session.clear
  redirect "/"
end

# Define routes below
get '/' do
  session[:login]=false
  current_user

  @messages = Message.all.reverse

  if session[:from_num].nil?
    session[:from_num] = 0
    session[:reached_last] = false
  end

  @next_group_messages = next_group_messages(5,@messages)

  @users = User.all
  erb :index
end

post '/next' do
  redirect '/'
end

# login
post '/login' do
  if User.find_by(username: params[:username].downcase) == nil
    user = User.create(username: params[:username], password: params[:password])
    session[:user_id]=user.id
    session[:from_num] = nil
    redirect "/"
  else
    user = User.find_by(username: params[:username].downcase)
    if user.password = params[:password]
        session[:user_id]=user.id
        session[:from_num] = nil
        redirect '/'
    else
      erb :login
    end
  end
end

post '/messages' do
  if !current_user
    redirect "/login"
  end
    message = Message.create(user_id:current_user.id, body:params[:body])
    session[:from_num] = nil
    redirect "/"
end

get '/messages/new' do
  erb :'messages/new'
end

get '/messages/:id' do
  @message = Message.find_by_id(params[:id])
  erb :'messages/show'
end

get '/profile/show/:id' do
  erb :'profile/show'
end

patch '/profile/edit/:id' do
    session[:edit_mode]=false
    current_user.update(fname: params[:first_name],lname: params[:last_name])
    redirect "/profile/show/#{params[:id]}"
end

post '/profile/edit/:id' do
    session[:edit_mode]=true
    redirect "/profile/show/#{params[:id]}"
end

delete '/profile/delete' do
  current_user
  @user.destroy
  binding.pry
  session.clear
  redirect "/"
end

# Providing model information to the view
# requires an instance variable (prefixing with the '@' symbol)

# Example 'User' index route

# get '/users' do
#   @users = User.all
#   erb :users
# end
