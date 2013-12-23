class Event < ActiveRecord::Base
  serialize :payload, JSON
end
