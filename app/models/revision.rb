class Revision < ActiveRecord::Base
  has_many :events
  validate :must_have_events

  validates :resource_type, presence: true
  validates :resource_uuid, presence: true
  validates :resource_version, presence: true, 
    numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  private

  def must_have_events
    errors.add :events, "must contain at least one event" if events.empty?
  end

end

def Revision.find_conflicting revision
  self.find_by \
    resource_type: revision.resource_type,
    resource_uuid: revision.resource_uuid,
    resource_version: revision.resource_version
end
