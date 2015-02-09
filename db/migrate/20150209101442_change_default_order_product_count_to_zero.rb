class ChangeDefaultOrderProductCountToZero < ActiveRecord::Migration
  def change
    change_column_default :order_products, :count, 0
  end
end
