class CreateRevisions < ActiveRecord::Migration
  def change
    create_table :revisions do |t|
      t.string :resource_type_name
      t.string :resource_uuid
      t.integer :resource_version

      t.index [:resource_type_name, :resource_uuid, :resource_version], unique: true, name: "index_revisions_resource"
    end
  end
end
