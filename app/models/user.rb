class User < ApplicationRecord

  # Adds methods to set and authenticate against a Bcrypt password
  # requires "password_digest" in user schema/migration
  # has_secure_password

  # sets up relationships
  has_many :user_datasets
  has_many :datasets, through: :user_datasets


end
