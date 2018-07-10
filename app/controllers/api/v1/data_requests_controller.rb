class Api::V1::DataRequestsController < ApplicationController

  def show
    # make a request(s) for the 3rd party data as described in dataset
    # get ID from user calculate 30 days of index and return values

    # find the current user by ID
    @user = User.find(params["id"])

    #find the current users data prefrences
    @userDatasets = UserDataset.where("user_id = #{@user.id}")

    #find all datasets that the user has interacted with
    #!!! consider grabbing all datasets rather than this subset !!!
    @datasets = @userDatasets.map{ |user_data| Dataset.where("id = #{user_data.dataset_id}")[0]}

    #basedoom value - reduces volitility in index
    baseDoom = 5

    #store data from API requests [{dataset:values},{dataset:values}]
    dataPackage = getDataSets

    index = get31days.map{ |day|
      indexValueSet = dataPackage.map{ |dataset|
        dataRelationship = @userDatasets.find{ |userdataset| userdataset.dataset_id == dataset[:id]}

        relationshipVector = (dataRelationship.positive_corral ? 1 : -1)
        indexValuePartial = 0

        #if this day has a value in the dataset calculate the # of standard deviations from the mean it is, mulitply by the weight and multiply by -1 if the indicator is negatively related to doom --- else seek a value from the previous 10 days
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
       #calcualte weighted average of proccessed values and add basedoom to determine this days index value
       {day=>(((indexValueSet.inject(0, :+))/getTotalWeights) + baseDoom)}
     }

     #send back 30 days of caluclated doom values
    render json: index
  end


private


  def proccesPresApproval(dataset)
    # grabs a CSV from provided src address and standardizes it for doom index proccessing
    # !! consider adding params and combining with proccesGenericBallot
    data = {}
    CSV.new(open(dataset), :headers => :first_row).each do |line|
      if line[1] == "All polls"
        data[DateTime.parse(line[9]).strftime("%d/%m/%Y")] = line[3]
      end
    end
    data.reverse_each.to_h
  end

  def proccesGenericBallot(dataset)
    # grabs a CSV from provided src address and standardizes it for doom index proccessing
    # !! consider adding params and combining with proccesPresApproval
    data = {}
    CSV.new(open(dataset), :headers => :first_row).each do |line|
      if line[0] == "All polls"
        data[DateTime.parse(line[8]).strftime("%d/%m/%Y")] = line[2]
      end
    end
    data.reverse_each.to_h
  end

  def proccesFRED(dataset)
    #requests a JSON dataset from FRED given a source and formats for doom index proccessing
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

  def proccessSeaIce(dataset)
    puts "START ICE REQUEST"
    xlsx = Roo::Spreadsheet.open(dataset)
    puts "GOT ICE REQUEST"
    anomData = xlsx.sheet('NH-5-Day-Anomaly')
    lastColumn = anomData.last_column
    valueArr = []
    puts "START ICE ITERATION"
    anomData.column(lastColumn).each_with_index { |dataPoint, index|
      if index > 0 && (anomData.column(lastColumn)[index] || anomData.column(lastColumn)[index+1])
        if dataPoint != nil
          valueArr << dataPoint
        else
          valueArr << anomData.column(lastColumn)[index-1]
        end
      end
     }
     puts "END ICE ITERATION"
     data = {}
     valueArr.each_with_index{ |value, index|
       data[(Date.today - (valueArr.length - index)).strftime("%d/%m/%Y")] = value
     }
     data
  end

  def getMean(data)
    #calculates an avarage value from an array of hashes [{date:value}, {date:value}]
    ints = data.values.map{ |val| val.to_f}
    ints.inject{ |sum, el| sum + el }.to_f / ints.size
  end

  def getStdVar(data)
    #calculates a standard deviation value from an array of hashes [{date:value}, {date:value}]
    ints = data.values.map{ |val| val.to_f}
    m = getMean(data)
    sum = ints.inject(0){|accum, i| accum + (i - m) ** 2 }
    Math.sqrt(sum / (ints.length - 1).to_f)
  end

  def get31days
    # produces an array of dates including today and the previous 30 days
    days = []
    (0..30).each{ |num|
      days << (Date.today - num.days).strftime("%d/%m/%Y")
    }
    days
  end

  def getTotalWeights
    #calculates the total weights placed on various datasets by users
    weights = @userDatasets.map{ |set| set.weight }
    totalWeights = weights.inject(0, :+)
    if totalWeights == 0
      1
    else
      totalWeights
    end
  end

  def getDataSets
    # routes all datasets to the appropreate request and formatting funcntion
    @datasets.map{ |dataset|

      if Time.now - dataset.updated_at > 21600 || !dataset.notes
        puts "REFRESHING DATA"
        if dataset.name == "Presidential Approval"
          data = proccesPresApproval(dataset.srcAddress)
        elsif dataset.name == "Generic Ballot"
          data = proccesGenericBallot(dataset.srcAddress)
        elsif dataset.name == "S&P 500 Volatility"
          data = proccesFRED(dataset.srcAddress)
        elsif dataset.name == "Sea Ice Extent"
          data = proccessSeaIce(dataset.srcAddress)
        elsif dataset.name == "10Yr Treasury Minus 2Yr"
          data = proccesFRED(dataset.srcAddress)
        else
          puts "INCORRECT DATASET NAME"
        end
        dataForPackage = {data:data, mean:getMean(data), stdDev:getStdVar(data), name:dataset.name, id:dataset.id}
        dataset.notes = dataForPackage.to_json
        dataset.save
        dataset.touch
      else
        dataForPackage = JSON.parse(dataset.notes)
      end
      dataForPackage.symbolize_keys
     }
  end

end
