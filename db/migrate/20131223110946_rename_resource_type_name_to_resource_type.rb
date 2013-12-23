class RenameResourceTypeNameToResourceType < ActiveRecord::Migration
  def change
    rename_column :revisions, :resource_type_name, :resource_type
  end
end
