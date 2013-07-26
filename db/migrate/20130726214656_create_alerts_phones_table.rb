class CreateAlertsPhonesTable < ActiveRecord::Migration
  def up
    create_table :alerts_phones, :id => false do |t|
      t.references :alert
      t.references :phone
    end
    add_index :alerts_phones, [:alert_id, :phone_id]
    add_index :alerts_phones, :phone_id
  end

  def down
    drop_table :alerts_phones
  end
end