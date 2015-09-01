class Stock
  include ActiveModel::Model
  include ActiveModel::Validations

  def stock_entries
    @stockentries ||= []
  end

  def stock_entries_attributes=(attributes)
    attributes.each do |i, se_attr|
      stock_entries.push(StockEntry.new(se_attr))
    end
  end

  validate :validate_stock_entries
  def validate_stock_entries
    stock_entries.each do |se|
      unless se.valid?
        se.errors.each do |_, e|
          errors[se.product.name] = "count " + e
        end
      end
    end
  end

  def update
    return false unless valid?

    stock_entries.each do |se|
      se.product.increment!(:stock, se.count.to_i) if se.count.to_i > 0
    end
  end

  class StockEntry
    include ActiveModel::Model
    include ActiveModel::Validations

    validates :count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :product, presence: true

    def initialize(attributes={})
      super
      @count ||= 0
    end

    attr_accessor :product, :count

    def self.products
      @products ||= Product.all.to_a
    end

    def product_id
      @product.id
    end

    def product_id=(id)
      @product = StockEntry.products.select { |p| p.id == id.to_i }.first
    end
  end
end
