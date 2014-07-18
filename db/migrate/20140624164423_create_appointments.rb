class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.datetime :startdate
      t.datetime :enddate
      t.string :title
      t.text :notes
      t.integer :typeapp
      t.boolean :visibility

      t.timestamps
    end
  end
end
