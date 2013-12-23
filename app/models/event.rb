class Event < ActiveRecord::Base
  self.inheritance_column = :class_name
  serialize :payload, JSON
  validates :type, presence: true
  validates :occurred_at, presence: true
  validates :payload, presence: true
end
