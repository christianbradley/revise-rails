json.error do

  json.type "RevisionConflictError"
  json.message "Could not create this revision due to a conflict with an existing revision."

  json.revision do
    json.partial! "revisions/revision", revision: @revision
  end

  json.conflicting do 
    json.partial! "revisions/revision", revision: @conflict
  end

end
