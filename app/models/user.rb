class User < ApplicationRecord
  has_many :messages, dependent: :delete_all
  has_many :reactions, dependent: :delete_all
end
