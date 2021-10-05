class AddQuickpayHiddenToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :quickpay_hidden, :boolean, default: false
  end
end
