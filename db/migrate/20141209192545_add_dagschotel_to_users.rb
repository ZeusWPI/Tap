class AddDagschotelToUsers < ActiveRecord::Migration[4.2]
  def change
    add_reference :users, :dagschotel
  end
end
