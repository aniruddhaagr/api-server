require 'rails_helper'

RSpec.describe Api::V1::UsersController, :type => :controller  do

  context "#create" do
    it 'create user' do
      post :create, params: { user: { first_name: "Mike", last_name: "Pike", email: "dev-mike-pike@gmail.com", password: "Password$123" }}
      expect(response).to have_http_status(200)
    end

    it 'error while creating user' do
      post :create, params: { user: { first_name: "Mike", last_name: "Pike", password: "Password$123" }}
      expect(response).to have_http_status(422)
    end
  end

  context "#login" do
    let(:user) {
      User.create(first_name: "Mike", last_name: "Pike", email: "dev-mike-pike@gmail.com", password: "Password$123")
    }

    it 'logs user in' do
      post :login, params: { email: user.email, password: user.password }
      expect(response).to have_http_status(200)
    end

    it 'does not log user with wrong email' do
      post :login, params: { email: "dev-test@gmail.com" }
      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)["message"][0]).to eq('Email does not exist')
    end

    it 'does not log user with wrong password' do
      post :login, params: { password: "test" }
      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)["message"][0]).to eq('Email does not exist')
    end
  end

  context "#update" do
    let(:user) {
      User.create(first_name: "Mike", last_name: "Pike", email: "dev-mike-pike@gmail.com", password: "Password$123")
    }
    
    it 'does not update user' do
      post :login, params: { email: user.email, password: user.password }

      put :update, params: { user: { first_name: "Steve", last_name: "Smith" }}
      expect(response).to have_http_status(422)
    end

    it 'updates user' do
      post :login, params: { email: user.email, password: user.password }
      request.headers.merge!({"HTTP_AUTH_TOKEN" => user.tokens.last.auth_token})
      
      put :update, params: { user: { first_name: "Steve", last_name: "Smith" }}
      expect(response).to have_http_status(200)
    end
  end

  context "#sign_out" do
    let(:user) {
      User.create(first_name: "Mike", last_name: "Pike", email: "dev-mike-pike@gmail.com", password: "Password$123")
    }

    it 'does not logs out user' do
      user = 
      post :sign_out
      expect(response).to have_http_status(422)
    end
      
    it 'logs out user' do
      post :login, params: { email: user.email, password: user.password }
      request.headers.merge!({"HTTP_AUTH_TOKEN" => user.tokens.last.auth_token})

      post :sign_out
      expect(response).to have_http_status(200)
    end
  end
end
