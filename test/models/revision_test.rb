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
    event_attrs = { type_name: "UserRegistered", occurred_at: Time.zone.now, payload: "{}" }

    first = Revision.new revision_attrs
    first.events << Event.new(event_attrs)
    first.save!

    second = Revision.new revision_attrs
    event = Event.new type_name: "UserRegistered", occurred_at: Time.zone.now, payload: "{}"
    second.events << event

    assert_raises ActiveRecord::RecordNotUnique do
      second.save!
    end

    assert event.new_record?
  end

  def test_must_contain_at_least_one_event 
    revision_attrs = { resource_type_name: "User", resource_uuid: SecureRandom.uuid, resource_version: 0 }
    revision = Revision.new revision_attrs

    assert revision.invalid?
    assert revision.errors[:events].length == 1
  end

  def test_validates_presence
    revision = Revision.new 
    assert revision.invalid?
    assert_includes revision.errors[:resource_type_name], "can't be blank"
    assert_includes revision.errors[:resource_uuid], "can't be blank"
    assert_includes revision.errors[:resource_version], "can't be blank"
  end

  def test_validates_numericality_of_version
    revision = Revision.new resource_version: "foo"
    assert revision.invalid?
    assert_includes revision.errors[:resource_version], "is not a number"

    revision = Revision.new resource_version: -1
    assert revision.invalid?
    assert_includes revision.errors[:resource_version], "must be greater than or equal to 0"

    revision = Revision.new resource_version: 1.1
    assert revision.invalid?
    assert_includes revision.errors[:resource_version], "must be an integer"
  end

end
