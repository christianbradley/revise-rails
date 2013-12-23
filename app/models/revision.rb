class Revision < ActiveRecord::Base
  has_many :events
  validate :must_have_events

  private

  def must_have_events
    errors.add :events, "must contain at least one event" if events.empty?
  end

end
