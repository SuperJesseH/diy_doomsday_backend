# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


user1 = User.create(name: "dan", email: "dan@email.com", password: "password")
user2 = User.create(name: "amy", email: "amy@email.com", password: "password")

# DESCRIPTIONS MOSTLY FROM WIKIPEDIA

five38 = Dataset.create(name: "Presidential Approval Rating", srcName: "FiveThirtyEight", srcAddress: 'https://projects.fivethirtyeight.com/trump-approval-data/approval_topline.csv', desc:"Percentage of Americans who approve of the currrent president's job performance. A higher value indicates a greater chance of the President's agenda succeding in congress, American culture, and future elections.", normalizer:"percent")

five38_2 = Dataset.create(name: "Voter Preference for Democratic Candidates", srcName: "FiveThirtyEight", srcAddress: 'https://projects.fivethirtyeight.com/generic-ballot-data/generic_topline.csv', desc:"Percentage of Americans indicating a preference for Democrat Party candidates according to the latest polls. A higer value indicates a higher chance of Democrats winning congress in upcoming elections.", normalizer:"percent")

sp1 = Dataset.create(name: "Stock Market Volatility", srcName: "FRED", srcAddress: "https://api.stlouisfed.org/fred/series/observations?series_id=VXVCLS&api_key=#{ENV['FRED_SECRET']}&file_type=json", desc:"A popular measure of the stock market's expectation of volatility implied stock options, calculated and published by the CBOE. It is referred to as the fear index or the fear gauge. A Higher value means more volitility.", normalizer:"percent")

sp2 = Dataset.create(name: "Yield Curve", srcName: "FRED", srcAddress: "https://api.stlouisfed.org/fred/series/observations?series_id=T10Y2Y&api_key=#{ENV['FRED_SECRET']}&file_type=json", desc:"The slope of the yield curve is one of the most powerful predictors of future economic growth, inflation, and recessions. A high value can predict a strong and growing economy, a low or negative value often indicates a looming reccession.", normalizer:"percent")

sp3 = Dataset.create(name: "Inflation Rate", srcName: "FRED", srcAddress: "https://api.stlouisfed.org/fred/series/observations?series_id=T10YIE&api_key=#{ENV['FRED_SECRET']}&file_type=json", desc:"In economics, inflation is a sustained increase in price level of goods and services in an economy over a period of time. High or unpredictable inflation rates are regarded as harmful to an overall economy.", normalizer:"percent")

seaIce = Dataset.create(name: "Polar Ice Growth", srcName: "NSIDC", srcAddress: "ftp://sidads.colorado.edu/DATASETS/NOAA/G02135/seaice_analysis/Sea_Ice_Index_Daily_Extent_G02135_v3.0.xlsx", desc:"Measures the extent of arctic sea ice. If gradually warming temperatures melt sea ice over time, fewer bright surfaces are available to reflect sunlight back into space and temperatures rise further. A high value means there is more ice than expected", normalizer:"percent")

dandata1 = UserDataset.create(user_id: user1.id, dataset_id: five38.id, weight: 1)
dandata2 = UserDataset.create(user_id: user1.id, dataset_id: five38_2.id, weight: 4)
amydata1 = UserDataset.create(user_id: user2.id, dataset_id: five38.id, weight: 3)
amydata2 = UserDataset.create(user_id: user2.id, dataset_id: five38_2.id, weight: 3, positive_corral: false )
