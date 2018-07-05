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

    #basedoom value
    baseDoom = 5

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

    index = get31days.map{ |day|
      indexValueSet = dataPackage.map{ |dataset|

        dataRelationship = @userDatasets.find{ |userdataset| userdataset.dataset_id == dataset[:id]}

        relationshipVector = (dataRelationship.positive_corral ? 1 : -1)

        indexValuePartial = 0

        #if this day has a value in the dataset calculate the # of standard deviations from the mean it is, mulitply by the weight and multiplu by -1 if the indication is negatively related to doom --- else seek a value from the previous 10 days
        if dataset[:data][day]
          indexValuePartial = (((dataset[:data][day].to_f - dataset[:mean]) / dataset[:stdDev]) * dataRelationship.weight) * relationshipVector
        else
          (1..10).each { |index|
             if dataset[:data][(DateTime.parse(day) - index).strftime("%d/%m/%Y")]
               indexValuePartial =(((dataset[:data][(DateTime.parse(day) - index).strftime("%d/%m/%Y")].to_f - dataset[:mean]) / dataset[:stdDev]) * dataRelationship.weight) * relationshipVector
               break
            end
          }
        end
        indexValuePartial
       }
       {day=>(indexValueSet.inject(0, :+) + baseDoom)}
     }

    render json: index
  end

  def create
  end

private

  def proccesPresApproval(dataset)
    data = {}
    CSV.new(open(dataset), :headers => :first_row).each do |line|
      if line[1] == "All polls"
        data[DateTime.parse(line[9]).strftime("%d/%m/%Y")] = line[3]
      end
    end
    data.reverse_each.to_h
  end

  def proccesGenericBallot(dataset)
    data = {}
    CSV.new(open(dataset), :headers => :first_row).each do |line|
      if line[0] == "All polls"
        data[DateTime.parse(line[8]).strftime("%d/%m/%Y")] = line[2]
      end
    end
    data.reverse_each.to_h
  end

  def proccesFRED(dataset)
    uri = URI.parse(dataset)
    response = Net::HTTP.get_response(uri)
    valueArr = JSON response.body

    data = {}
    valueArr["observations"].each{ |dataInstance|
      if dataInstance["value"] != "."
       data[DateTime.parse(dataInstance["date"]).strftime("%d/%m/%Y")] = dataInstance["value"]
      end
    }
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

  def get31days
    days = []
    (0..30).each{ |num|
      days << (Date.today - num.days).strftime("%d/%m/%Y")
    }
    days
  end



end
