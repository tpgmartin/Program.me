class CreateReadings < ActiveRecord::Migration
  def change
    create_table :readings, :id => false do |t|
      t.integer :user_id
      t.integer :event_id
    end
  end
end