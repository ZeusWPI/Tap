class InStockValidator < ActiveModel::Validator
  def validate(record)
    p_short = []
    record.order_items.each do |oi|
      p_short.append oi.product.name if oi.count > oi.product.stock
    end
    record.errors.add(:base, "There is not enough stock for your order of the following products: #{p_short.join(', ')}") if p_short.size > 0
  end
end
