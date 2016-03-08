class AddQuickpayHiddenToUser < ActiveRecord::Migration
  def change
    add_column :users, :quickpay_hidden, :boolean, default: false
  end
end
