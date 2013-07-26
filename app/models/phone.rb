class Phone < ActiveRecord::Base
  attr_accessible :phone_number
  has_and_belongs_to_many :alerts
end
