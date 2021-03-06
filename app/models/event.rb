class Event < ActiveRecord::Base
  self.inheritance_column = :class_name
  serialize :payload, JSON
  validates :type, presence: true
  validates :occurred_at, presence: true
  validates :payload, presence: true
end

def Event.build_from_json_hash attributes
  self.new \
    type: attributes[:type],
    occurred_at: attributes[:occurredAt],
    payload: attributes[:payload]
end
