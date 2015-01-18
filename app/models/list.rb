class List < ActiveRecord::Base
  belongs_to :user
  has_one :user
  has_many :items
end
