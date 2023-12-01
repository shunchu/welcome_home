class CreateResidents < ActiveRecord::Migration[7.1]
  def change
    create_table :residents do |t|
      t.string :first_name, :null => false
      t.string :last_name, :null => false
      t.timestamps
    end

    add_index(:residents, [:id], :name => :id_idx)
    add_index(:residents, [:id], :unique => true, :name => :id_unq_idx)
    add_index(:residents, [:first_name], :name => :first_name_idx)
    add_index(:residents, [:last_name], :name => :last_name_idx)
  end
end
