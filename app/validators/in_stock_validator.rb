class InStockValidator < ActiveModel::Validator
  def validate(record)
    record.order_products.each do |op|
      record.errors[op.product.name] = "is not in stock anymore" if op.count > op.product.stock
    end
  end
end
