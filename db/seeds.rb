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

five38_2 = Dataset.create(name: "Generic Ballot", srcName: "FiveThirtyEight", srcAddress: 'https://projects.fivethirtyeight.com/generic-ballot-data/generic_topline.csv', desc:"generic ballot reps vs dems", normalizer:"percent")

sp1 = Dataset.create(name: "S&P 500 CAPE", srcName: "Datahub.io", srcAddress: 'https://datahub.io/core/s-and-p-500/r/data.csv', desc:"The CAPE ratio, an acronym for Cyclically Adjusted P/E (Price-Earnings) ratio", normalizer:"percent")

sp2 = Dataset.create(name: "10-Year U.S. Treasury", srcName: "Datahub.io", srcAddress: 'https://datahub.io/core/s-and-p-500/r/data.csv', desc:"Interest rate of 10 year bonds", normalizer:"percent")

dandata1 = UserDataset.create(user_id: user1.id, dataset_id: five38.id, weight: 1)
dandata2 = UserDataset.create(user_id: user1.id, dataset_id: five38_2.id, weight: 7)
amydata1 = UserDataset.create(user_id: user2.id, dataset_id: five38.id, weight: 3)
