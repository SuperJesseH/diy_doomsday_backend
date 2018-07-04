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
      dataPackage = {data:data, mean:getMean(data), stdDev:getStdVar(data)}
    elsif @dataset.name == "Generic Ballot"
      data = proccesGenericBallot(@dataset.srcAddress)
      dataPackage = {data:data, mean:getMean(data), stdDev:getStdVar(data)}
    elsif @dataset.name == "S&P 500 Volatility"
      data = proccesFRED(@dataset.srcAddress)
      dataPackage = {data:data, mean:getMean(data), stdDev:getStdVar(data)}
    elsif @dataset.name == "10-Year Treasury Minus 2-Year Treasury"
      data = proccesFRED(@dataset.srcAddress)
      dataPackage = {data:data, mean:getMean(data), stdDev:getStdVar(data)}
    end

    render json: dataPackage
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
    data.reverse_each.to_h
  end

  def proccesGenericBallot(dataset)
    data = {}
    CSV.new(open(dataset), :headers => :first_row).each do |line|
      if line[0] == "All polls"
        data[line[8]] = line[2]
      end
    end
    data.reverse_each.to_h
  end

  def proccesFRED(dataset)
    uri = URI.parse(dataset)
    response = Net::HTTP.get_response(uri)
    valueArr = JSON response.body

    data = {}
    # check for zeros
    valueArr["observations"].each{ |dataInstance| data[dataInstance["date"]] = dataInstance["value"]}
    data
  end

  def getMean(data)
    ints = data.values.map{ |val| val.to_f}
    ints.inject{ |sum, el| sum + el }.to_f / ints.size
  end

  def getStdVar(data)
    ints = data.values.map{ |val| val.to_f}
    m = getMean(data)
    sum = ints.inject(0){|accum, i| accum + (i - m) ** 2 }
    Math.sqrt(sum / (ints.length - 1).to_f)
  end



end
