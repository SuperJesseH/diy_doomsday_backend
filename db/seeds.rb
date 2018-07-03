# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


user1 = User.create(name: "dan", email: "dan@email.com", password: "password")
user2 = User.create(name: "amy", email: "amy@email.com", password: "password")


five38 = Dataset.create(name: "Presidential Approval", srcName: "FiveThirtyEight", srcAddress: 'https://projects.fivethirtyeight.com/trump-approval-data/approval_topline.csv', desc:"presidential approval figures", normalizer:"percent")

five38_2 = Dataset.create(name: "Generic Ballot", srcName: "FiveThirtyEight", srcAddress: 'https://projects.fivethirtyeight.com/generic-ballot-data/generic_topline.csv', desc:"Percent of Americans indicating a prefrence for Democrat candidates", normalizer:"percent")

sp1 = Dataset.create(name: "S&P 500 Volatility", srcName: "FRED", srcAddress: "https://api.stlouisfed.org/fred/series/observations?series_id=VXVCLS&api_key=#{ENV['FRED_SECRET']}&file_type=json", desc:"Measures price volatility among the 500 largest publicly traded companies in the U.S.", normalizer:"percent")

sp2 = Dataset.create(name: "10-Year Treasury Minus 2-Year Treasury", srcName: "FRED", srcAddress: "https://api.stlouisfed.org/fred/series/observations?series_id=T10Y2Y&api_key=#{ENV['FRED_SECRET']}&file_type=json", desc:"A high value indicates expectations for faster economic growth in the future", normalizer:"percent")

dandata1 = UserDataset.create(user_id: user1.id, dataset_id: five38.id, weight: 1)
dandata2 = UserDataset.create(user_id: user1.id, dataset_id: five38_2.id, weight: 4)
amydata1 = UserDataset.create(user_id: user2.id, dataset_id: five38.id, weight: 3)
