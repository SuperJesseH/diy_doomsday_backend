class UserSerializer < ActiveModel::Serializer
  attributes :name, :id
  has_many :user_datasets
  has_many :datasets, through: :user_datasets
end
