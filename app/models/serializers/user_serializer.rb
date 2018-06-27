class UserSerializer < ActiveModel::UserSerializer
  attributes: :name
  has_many :user_datasets
  has_many :datasets, through: :user_datasets
end
