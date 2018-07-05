class Api::V1::DataRequestsController < ApplicationController


  def index
    #
    render json: @data
  end

  def show
    # make a request for the 3rd party data as described in dataset
    #get ID from user calculate 30 days of index and return values
    @user = User.find(params["id"])

    @userDatasets = UserDataset.where("user_id = #{@user.id}")

    @datasets = @userDatasets.map{ |user_data| Dataset.where("id = #{user_data.dataset_id}")[0]}


    dataPackage = @datasets.map{ |dataset|

      if dataset.name == "Presidential Approval"
        data = proccesPresApproval(dataset.srcAddress)
      elsif dataset.name == "Generic Ballot"
        data = proccesGenericBallot(dataset.srcAddress)
      elsif dataset.name == "S&P 500 Volatility"
        data = proccesFRED(dataset.srcAddress)
      elsif dataset.name == "10-Year Treasury Minus 2-Year Treasury"
        data = proccesFRED(dataset.srcAddress)
      end

      dataForPackage = {data:data, mean:getMean(data), stdDev:getStdVar(data), name:dataset.name, id:dataset.id}

     }



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
