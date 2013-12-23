class Event < ActiveRecord::Base
  serialize :payload, JSON
  validates :type_name, presence: true
  validates :occurred_at, presence: true
  validates :payload, presence: true
end
