class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :type_name
      t.datetime :occurred_at
      t.text :payload
    end
  end
end
