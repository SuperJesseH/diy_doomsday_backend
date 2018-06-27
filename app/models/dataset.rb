class Dataset < ApplicationRecord

  # sets up relationships
  has_many :user_datasets
  has_many :users, through: :user_datasets

end
