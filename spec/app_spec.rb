ENV['RACK_ENV'] = 'test'

require_relative '../app.rb'  # <-- your sinatra app
require 'rspec'
require 'sinatra'
require 'rack/test'

describe 'App' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "says hello" do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to include('Hello World')
  end
end
