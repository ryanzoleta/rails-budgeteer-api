class Account < ApplicationRecord
  belongs_to :account_type
  has_many :transactions
end
