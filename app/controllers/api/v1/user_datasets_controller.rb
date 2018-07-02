class Api::V1::UserDatasetsController < ApplicationController

  def index
    # shows all users data and weights
    # api/v1/user_datasets
    @userDataset = UserDataset.all
    render json: @userDataset
  end

  def show
    # shows specific users data and weights
    # api/v1/user_datasets/{user_id}
    @UserSet = UserDataset.select{ |item| item[:user_id] == params["id"].to_i}
    render json: @UserSet
  end

  def create
  end

  def update
  end

  # add strong params
end
