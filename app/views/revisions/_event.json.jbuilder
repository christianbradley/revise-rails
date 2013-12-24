json.type event.type
json.occurredAt event.occurred_at
json.payload event.payload

json.partial! "revisions/errors", errors: event.errors
