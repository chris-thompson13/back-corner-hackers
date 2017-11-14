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

def load_messages
  @messages = Message.all.reverse
  @next_group_messages = next_group_messages(10,@messages)
  session[:num_items_on_current_page] = @next_group_messages.length
  @users = User.all
  erb :index
end

get '/login' do
  session[:login]=true
  erb :login
end

get '/logout' do
  session.clear
  redirect "/"
end

# Define routes below
get '/' do
  session[:login]=false
  session[:in_profile_page] = false
  current_user


  session[:from_num] = 0
  session[:reached_last] = false
  load_messages
end

post '/next' do
  load_messages
end

post '/prev' do
  session[:from_num] -= session[:num_items_on_current_page]
  session[:from_num] -= 10
  if session[:from_num] < 0
    session[:from_num] =0
  end
  session[:reached_last] = false
  load_messages
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
  session[:in_profile_page] = true
  erb :'profile/show'
end

patch '/profile/edit/:id' do
  session[:in_profile_page] = true
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
