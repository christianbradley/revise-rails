json.count @revisions.count
json.revisions do
  json.array! @revisions, partial: "revisions/revision", as: :revision
end

