class CreateDagschotels < ActiveRecord::Migration[5.1]
  def change
    create_table :dagschotels do |t|
      t.references :user
      t.references :product

      t.timestamps
    end

    remove_column :users, :dagschotel_id, :integer
    remove_column :users, :koelkast, :boolean
  end
end
