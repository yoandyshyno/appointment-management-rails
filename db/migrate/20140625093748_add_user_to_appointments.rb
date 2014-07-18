class AddUserToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :user, :integer
  end
end
