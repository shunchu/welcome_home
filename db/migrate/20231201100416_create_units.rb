class CreateUnits < ActiveRecord::Migration[7.1]
  def change
    create_table :units do |t|
      t.string :floor_plan, :null => false
      t.string :number, :null => false
      t.timestamps
    end

    add_index(:units, [:id], :name => :id_idx)
    add_index(:units, [:id], :unique => true, :name => :id_unq_idx)
    add_index(:units, [:floor_plan], :name => :floor_plan_idx)
    add_index(:units, [:number], :name => :number_idx)
  end
end
