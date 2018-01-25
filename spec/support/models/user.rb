class User < ActiveRecord::Base
  has_many :houses
  has_many :cars
  has_many :shoes

  has_many :rooms, through: :houses

  has_one :spouse, class_name: 'User', foreign_key: :spouse_id
  has_one :profile

  belongs_to :club
  belongs_to :age_group
end
