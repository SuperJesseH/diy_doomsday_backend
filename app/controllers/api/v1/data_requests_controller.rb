class Api::V1::DataRequestsController < ApplicationController


  def index
    #grab all avalible datasets
    @data = {day1:123, day2:12345}
    #send all datasets to client in JSON format
    render json: @data
  end

  def show
    # make a request for the 3rd party data as described in dataset
    @dataset = Dataset.find(params["id"])

    if @dataset.name == "Presidential Approval"
      data = proccesPresApproval(@dataset.srcAddress)
    elsif @dataset.name == "Generic Ballot"
      data = proccesGenericBallot(@dataset.srcAddress)
    elsif @dataset.name == "Generic ballot"
      data = proccesGenericBallot(@dataset.srcAddress)
    end

    render json: data
  end

  def create
  end

private

  def proccesPresApproval(dataset)
    data = {}
    CSV.new(open(dataset), :headers => :first_row).each do |line|
      if line[1] == "All polls"
        data[line[9]] = line[3]
      end
    end
    data
  end

  def proccesGenericBallot(dataset)
    data = {}
    CSV.new(open(dataset), :headers => :first_row).each do |line|
      if line[0] == "All polls"
        data[line[8]] = line[2]
      end
    end
    data
  end

end
