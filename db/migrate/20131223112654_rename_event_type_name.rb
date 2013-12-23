class RenameEventTypeName < ActiveRecord::Migration
  def change
    rename_column :events, :type_name, :type
  end
end
