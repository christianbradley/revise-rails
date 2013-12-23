class EventsReferencesRevisions < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.references :revision
    end
  end
end
