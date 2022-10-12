class Menu < ApplicationRecord
  validates  :name, presence: true, uniqueness: true
  validates  :slug,  uniqueness: true
  has_many  :permissions
end
