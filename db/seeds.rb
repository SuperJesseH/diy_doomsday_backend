# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


user1 = User.create(name: "dan", email: "dan@email.com")
user2 = User.create(name: "amy", email: "amy@email.com")


five38 = Dataset.create(name: "Presidential Approval", src: 'https://projects.fivethirtyeight.com/trump-approval-data/approval_topline.csv', desc:"presidential approval figures", normalizer:"percent")

five38_2 = Dataset.create(name: "Generic ballot", src: 'https://projects.fivethirtyeight.com/generic-ballot-data/generic_topline.csv', desc:"generic ballot reps vs dems", normalizer:"percent")


t.integer :user_id
t.integer :dataset_id
t.float :weight
t.string :notes

dandata1 = UserDataset.create(user_id: user1.id, dataset_id: five38.id, weight: 0.25)
dandata2 = UserDataset.create(user_id: user1.id, dataset_id: five38_2.id, weight: 0.35)
amydata1 = UserDataset.create(user_id: user2.id, dataset_id: five38.id, weight: 0.15)
