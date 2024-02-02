class Employee < ApplicationRecord
  has_many :attendances
  belongs_to :roster
  has_many :pay_items
end
