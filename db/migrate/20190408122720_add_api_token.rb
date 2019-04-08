class AddApiToken < ActiveRecord::Migration
  def change
    add_column :users, :userkey, :string

    User.all.each do |user|
      user.generate_key
      user.save
    end
  end
end
