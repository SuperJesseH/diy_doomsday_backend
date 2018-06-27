class UserDataset < ApplicationRecord

  # sets up relationships
  has_many :users
  has_many :datasets
end
