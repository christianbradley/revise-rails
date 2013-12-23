require 'test_helper'
require "securerandom"

class RevisionTest < ActiveSupport::TestCase
  
  def test_creating_with_events
    registered = Event.new type_name: "UserRegistered", occurred_at: Time.zone.now, payload: "{}"
    set_password = Event.new type_name: "PasswordSet", occurred_at: Time.zone.now, payload: "{}"

    revision = Revision.new resource_type_name: "User", resource_uuid: SecureRandom.uuid, resource_version: 0
    revision.events << registered
    revision.events << set_password
    revision.save!

    assert_equal revision.events.first, registered
    assert_equal revision.events.last, set_password
  end

  def test_resource_must_be_unique
    revision_attrs = { resource_type_name: "User", resource_uuid: SecureRandom.uuid, resource_version: 0 }

    first = Revision.new revision_attrs
    first.save!

    second = Revision.new revision_attrs
    event = Event.new type_name: "UserRegistered", occurred_at: Time.zone.now, payload: "{}"
    second.events << event

    assert_raises ActiveRecord::RecordNotUnique do
      second.save!
    end

    assert event.new_record?
  end

end