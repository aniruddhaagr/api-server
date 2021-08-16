class Api::V1::UsersController < ApplicationController
    def index
      render json: [{a: 'a', b: 'b'}]
    end

    def create
      user = User.create(user_params)
      user.password = params[:password]
      if user.save
        render json: { user_id: user.id} , status: :ok
      else
        render json: user.errors, status: 422
      end
    end

    def login
      user = User.find_by(email: params[:email])
      return render json: {email: 'email does not exist'}, status: 422 unless user
      return render json: {password: 'Password not valid'}, status: 422 unless user.valid_password?(params[:password])
      render json: {token: '000000'}
    end

    private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password)
    end
end
