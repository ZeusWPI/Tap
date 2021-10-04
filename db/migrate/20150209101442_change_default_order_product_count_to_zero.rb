class ChangeDefaultOrderProductCountToZero < ActiveRecord::Migration[4.2]
  def change
    change_column_default :order_products, :count, 0
  end
end
