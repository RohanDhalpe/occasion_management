class UsersController < ApplicationController
  load_and_authorize_resource except: [:login, :create]
  skip_before_action :authorize_request!, only: [:login, :create]

  def index
    if current_user
      @users = User.where(id: current_user.id)
      render json: @users
    else
      render json: { error: I18n.t('errors.unauthorized') }, status: :unauthorized
    end
  end

  def create
    @user = User.new(create_params)
    @user.role ||= Role.find_by(name: 'CUSTOMER')

    if @user.save
      @token = encode_token(@user.id)
      render json: { user: @user, token: @token }
    else
      render json: { error: I18n.t('errors.user_create_error', errors: @user.errors.full_messages.join(', ')) }, status: :unprocessable_entity
    end
  end

  def login
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      token = encode_token(id: @user.id)
      render json: { user: @user, token: token }
    else
      render json: { error: I18n.t('errors.invalid_credentials') }
    end
  end

  def show
    @user = User.find(params[:id])
    render json: @user
  end

  def update
    if @user.update(update_params)
      render json: @user
    else
      render json: { error: I18n.t('errors.user_update_error', errors: @user.errors.full_messages.join(', ')) }, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      render json: { message: 'User deleted successfully.' }
    else
      render json: { error: 'Unable to delete user.' }, status: :unprocessable_entity
    end
  end

  private

  def create_params
    params.require(:user).permit(:email, :password, :name)
  end

  def update_params
    params.require(:user).permit(:name, :email)
  end
end
