class Api::V1::DatasetsController < ApplicationController


  def index
    #grab all avalible datasets
    @data = Dataset.all
    #send all datasets to client in JSON format
    render json: @data
  end

  def show

  end

  def create
  end


end
