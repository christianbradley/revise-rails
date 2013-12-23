require 'test_helper'

class EventTest < ActiveSupport::TestCase
  def test_serializes_json
    hash = { "some" => "json" }
    event = Event.new type_name: "UserRegistered", occurred_at: Time.zone.now, payload: hash
    event.save!

    event.reload

    assert_equal event.payload, hash
  end
end
