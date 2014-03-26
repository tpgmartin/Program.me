class AddRecipentEmailToEvents < ActiveRecord::Migration
  def change
    add_column :events, :sender_id, :integer
    add_column :events, :recipient_email, :string
    add_column :events, :sent_at, :datetime
  end
end
