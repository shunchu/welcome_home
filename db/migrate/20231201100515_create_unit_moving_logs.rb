class CreateUnitMovingLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :unit_moving_logs do |t|
      t.references :unit
      t.string :resident_name
      t.date :move_in_on
      t.date :move_out_on
      t.timestamps
    end

    add_index(:unit_moving_logs, [:id], :name => :unit_moving_logs_id_idx)
    add_index(:unit_moving_logs, [:id], :unique => true, :name => :unit_moving_logs_id_unq_idx)
    add_index(:unit_moving_logs, [:unit_id], :name => :unit_id_idx)
    add_index(:unit_moving_logs, [:resident_name], :name => :resident_name_idx)
    add_index(:unit_moving_logs, [:move_in_on], :name => :move_in_on_idx)
    add_index(:unit_moving_logs, [:move_out_on], :name => :move_out_on_idx)
  end
end
