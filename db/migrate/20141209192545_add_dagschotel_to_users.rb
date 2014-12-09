class AddDagschotelToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :dagschotel
  end
end
