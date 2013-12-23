json.id revision.id
json.url revision_url(revision) unless revision.id.nil?

json.resourceType revision.resource_type
json.resourceUUID revision.resource_uuid
json.resourceVersion revision.resource_version

json.events do
  json.array! revision.events, partial: "revisions/event", as: :event
end

if revision.errors.any?
  json.errors do
    json.array! revision.errors
  end
end
