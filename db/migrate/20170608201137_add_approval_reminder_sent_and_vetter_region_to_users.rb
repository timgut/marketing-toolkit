class AddApprovalReminderSentAndVetterRegionToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :approval_reminder_sent, :datetime, null: true
    add_column :users, :vetter_region, :string, null: true
  end
end
