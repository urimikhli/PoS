class LineItem
  attr_reader :line_item
  def initialize(product)
    @line_item = { product: product }
    increment_quantity
  end

  def increment_quantity
    if @line_item[:quantity].nil?
      @line_item[:quantity] = 0
    end

    @line_item[:quantity] += 1
  end

  def decrement_quantity
    return if @line_item[:quantity].nil?
    return if @line_item[:quantity] == 0 # no negative quantities
    @line_item[:quantity] -= 1
  end

  def quantity
    @line_item[:quantity]
  end

  def price
    @line_item[:product].price
  end

  def product_code
    @line_item[:product].product_code
  end

  def discount_total
    return if @line_item[:product].discount_total.nil?
    @line_item[:product].discount_total
  end

  def discount_point
    return if @line_item[:product].discount_point.nil?
    @line_item[:product].discount_point
  end

  def item_total
    calculate_total_with_discounts(self.quantity, self.price, self.discount_point, self.discount_total)
  end
  private

  def calculate_total_with_discounts(quantity, price, discount_point, discount_total)

    return price * quantity if discount_point.nil?

    remainder = quantity % discount_point

    if quantity < discount_point
      price * quantity  #regular subtotal
    elsif discount_point == quantity
      #apply discount
      discount_total
    else
      times_discount_applied = (quantity - remainder) / discount_point#e.g.  17%3 -- qty:17 discount_point:3 -- remainder:2 --> (17 -2) / 3 =  5 times the discount was applied
      discount_total * times_discount_applied  +  ( price * remainder )   #too simple for recursion: calculate_discount(discount, remainder, price)
    end
  end
end