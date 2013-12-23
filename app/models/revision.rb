class Revision < ActiveRecord::Base
  has_many :events
end
