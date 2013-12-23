json.id revision.id
json.url revision_url(revision)

json.resource do
  json.type revision.resource_type_name
  json.uuid revision.resource_uuid
  json.version revision.resource_version
end

json.events do
  json.array! revision.events, partial: "revisions/event", as: :event
end
