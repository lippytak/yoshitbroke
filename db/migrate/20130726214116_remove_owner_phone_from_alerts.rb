class RemoveOwnerPhoneFromAlerts < ActiveRecord::Migration
  def up
    remove_column :alerts, :owner_phone
  end

  def down
    add_column :alerts, :owner_phone, :string
  end
end
