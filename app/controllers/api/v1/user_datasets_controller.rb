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
    @userSet = UserDataset.select{ |item| item[:user_id] == params["id"].to_i}
    render json: @userSet
  end

  def create
    # If no relationship exists create it, else update it then return specific users data and weights
    @userSet = UserDataset.where(:user_id => params["user_id"], :dataset_id => params["dataset_id"]).first_or_create
    @userSet.weight = params["weight"]
    @userSet.positive_corral = params["positive_corral"]
    # delete if no longer weighted
    if @userSet.weight > 0
      @userSet.save
    else
      UserDataset.delete(@userSet.id)
    end

    if @userSet
      render json: @userSet
    end
  end

  #!! add strong params
end
