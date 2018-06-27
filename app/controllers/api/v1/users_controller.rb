class Api::V1::UsersController < ApplicationController
  def index
    #grab all users
    @users = User.all
    #send all users to client in JSON format
    render json: @users
  end

  def show
  end

  def create
  end
end
