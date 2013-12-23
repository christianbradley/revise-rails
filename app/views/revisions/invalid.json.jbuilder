json.error do

  json.type "ValidationError"
  json.message "Could not save this revision due to invalid parameters."

  json.revision do
    json.partial! "revisions/revision", revision: @revision
  end

end
