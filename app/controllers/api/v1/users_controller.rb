#This class use to handle user operation
class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user, only: %i[profile sign_out update]

  #Register new user
  def create
    user = User.create(user_params)
    user.password = params[:password]
    if user.save
      render json: { message: 'success' }, status: :ok
    else
      render json: { message: user.errors.full_messages }, status: 422
    end
  end

  # Sign-in user with password and send back latest generated auth token
  def login
    user = User.find_by(email: params[:email])
    return render json: { message: ['Email does not exist'] }, status: 422 unless user
    return render json: { message: ['Password not valid'] }, status: 422 unless user.valid_password?(params[:password])

    token = user.tokens.create
    render json: { auth_token: token.auth_token }, status: :ok
  end

  # Send current user details
  def profile
    render json: @current_user
  end

  #Update user details except password
  def update
    if @current_user.update(user_params)
      render json: { message: 'success' }, status: :ok
    else
      render json: { message: @current_user.errors.full_messages }, status: 422
    end
  end

  # Destroy auth-token to sign-out
  def sign_out
    @token.destroy
    render json: { message: 'Sign-out successfully' }, status: :ok
  end

  private

  # Authenticate user with token and set current user
  def authenticate_user
    @token = Token.find_by(auth_token: request.headers['HTTP_AUTH_TOKEN'])
    return render json: { message: 'token invalid' }, status: 422 unless @token

    @current_user = @token.user
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end

  def user_update_params
    params.require(:user).permit(:first_name, :last_name, :email)
  end
end
