require 'spec_helper'

describe HomeController do
  describe 'GET index' do
    it 'has a 200 status code' do
      get :index
      response.code.should eq('200')
      response.should render_template('index')
    end
  end
end