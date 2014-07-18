class RemoveTypeappFromAppointments < ActiveRecord::Migration
  def change
    remove_column :appointments, :typeapp, :integer
  end
end
