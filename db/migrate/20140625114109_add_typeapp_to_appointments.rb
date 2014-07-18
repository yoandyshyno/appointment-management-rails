class AddTypeappToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :typeapp, :string
  end
end
