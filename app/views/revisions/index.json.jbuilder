json.count @revisions.count

json.revisions @revisions do |revision|

  json.id revision.id
  json.url revision_url(revision)

  json.resource do
    json.type revision.resource_type_name
    json.uuid revision.resource_uuid
    json.version revision.resource_version
  end

  json.events revision.events do |event|
    json.type event.type_name
    json.occurredAt event.occurred_at
    json.payload event.payload
  end

end
