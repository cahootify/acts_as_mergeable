class Profile < ActiveRecord::Base
  belongs_to :user
  belongs_to :county
  has_one :book
  has_many :emails
  has_and_belongs_to_many :clubs
end
