class MakeZauthIdNotNull < ActiveRecord::Migration[8.1]
  def change
    change_column_null :users, :zauth_id, false
  end
end
