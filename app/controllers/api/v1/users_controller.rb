class Api::V1::UsersController < ApplicationController
  def index
    #grab all users
    @users = User.all
    #send all users to client in JSON format
    render json: @users
  end

  def show
    # show specific users data
    @user = User.find(params['id'])
    render json: @user
  end

  def create
    # create new user through registration page and return JWT token 
    @user=User.new(user_params)

    if (@user.save)

      payload = {
        name: @user.name,
        email: @user.email,
        id: @user.id
      }

      token = JWT.encode payload, ENV['JWT_SECRET'], 'HS256'

      render json: {
        token: token,
        id: @user.id
       }

    else
      render json: {
        errors: @user.errors.full_messages}, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(
      :name,
      :email,
      :password,
      :notes
    )
  end

end
