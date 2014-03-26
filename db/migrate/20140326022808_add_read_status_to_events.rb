class AddReadStatusToEvents < ActiveRecord::Migration
  def change
    remove_column :events, :read
    add_column :events, :read_status, :boolean, :default => false
  end
end
