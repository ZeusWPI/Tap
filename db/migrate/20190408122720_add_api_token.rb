class AddApiToken < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :userkey, :string

    User.all.each do |user|
      user.generate_key
      user.save
    end
  end
end
