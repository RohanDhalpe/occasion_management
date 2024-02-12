class UsersController < ApplicationController
  load_and_authorize_resource  :except =>[:login, :create]
  skip_before_action :authorize_request!, only: [:login, :create]

  def index
    if params[:email]
      @users = User.where(email: params[:email])
    elsif params[:name]
      @users = User.where(name: params[:name])
    else
      @users = User.all
    end

    render json: @users
  end

  def create
    @user = User.create!(create_params)
    if @user.valid?
      @token = encode_token(@user.id)
      render json: { user: @user, token: @token }
    else
      render json: { error: 'Invalid parameters.' }
    end
  end

  def login
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      p @user
      token = encode_token({ id: @user.id })
      render json: { user: @user, token: token }
    else
      render json: { error: 'Invalid email or password.' }
    end
  end

  def update
    @user = User.find_by(id: params[:id])
    if @user.update(update_params)
      render json: @user
    else
      puts @user.errors.full_messages
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  def search
    begin
      @user = User.find_by!(email: params[:email])
      success_respose(@user)
      render json: @user
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'User not found.' }
    end
  end

  def destroy
    @user = User.find_by(id: params[:id])
    if @user
      @user.destroy
      render json: { message: 'User deleted successfully.' }
    else
      render json: { error: 'User not found.' }, status: :not_found
    end
  end

  private

  def create_params
    params.require(:user).permit(:email, :password, :name, :role_id)
  end

  def update_params
    params.require(:user).permit(:name, :email)
  end
end
