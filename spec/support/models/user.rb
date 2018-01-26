class User < ActiveRecord::Base

  acts_as_mergeable

  has_many :houses
  has_many :cars
  has_many :shoes

  has_many :rooms, through: :houses

  has_one :spouse, class_name: 'User', foreign_key: :spouse_id
  has_one :profile

  has_and_belongs_to_many :clubs

  belongs_to :age_group
end
