class InStockValidator < ActiveModel::Validator
  def validate(record)
    record.order_items.each do |oi|
      record.errors[oi.product.name] = "is not in stock anymore" if oi.count > oi.product.stock
    end
  end
end
