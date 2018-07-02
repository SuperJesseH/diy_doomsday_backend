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
    @userSet = UserDataset.where(:user_id => params["user_id"], :dataset_id => params["dataset_id"]).first_or_create

    @userSet.weight = params["weight"]

    @userSet.save
    
    puts @userSet.weight
    render json: @userSet
  end

  def update
  end

  # add strong params
end
