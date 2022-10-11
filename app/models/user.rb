class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_secure_password
  validates  :email, presence: true, uniqueness: true
  has_many  :login_histories
  has_many  :activity_streams
  belongs_to  :role
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :validatable
end
