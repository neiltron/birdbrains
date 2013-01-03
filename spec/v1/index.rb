require 'spec_helper'

describe Birdbrains::API , :type => :controller do
  include Rack::Test::Methods

  def app
    Birdbrains::API
  end

  context 'authenticated' do
    describe 'GET /1/home_timeline' do
      it 'returns tweet data' do
        get '/1/home_timeline'
        last_response.status.should == 200

        #JSON.parse(last_response.body)['id'].should == '8675309'
      end
    end
  end
end