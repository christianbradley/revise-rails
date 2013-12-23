json.type event.type_name
json.occurred_at event.occurred_at
json.payload event.payload

if event.errors.any?
  json.errors do
    json.array! event.errors
  end
end
