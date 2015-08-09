class Product
  attr_reader :product

  def initialize(product_hash = {})
    @product = product_hash
  end

  def product_code
    @product['product_code']
  end

  def price
    @product['price']
  end

  def discount_total
    return if @product['discounts'].empty?
    @product['discounts'].last['discount_total']
  end

  def discount_point
    return if @product['discounts'].empty?
    @product['discounts'].last['discount_point']
  end
end