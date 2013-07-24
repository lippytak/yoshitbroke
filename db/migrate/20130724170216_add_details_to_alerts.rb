class AddDetailsToAlerts < ActiveRecord::Migration
  def change
    add_column :alerts, :url, :string
    add_column :alerts, :owner_phone, :string
    add_column :alerts, :status, :integer
  end
end
