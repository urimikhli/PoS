class LineItem
  attr_reader :line_item
  def initialize(item_hash = {})
    @line_item = item_hash
    increment_quantity
  end

  def increment_quantity
    if @line_item['quantity'].nil?
      @line_item['quantity'] = 0
    end

    @line_item['quantity'] += 1
  end

  def decrement_quantity
    return if @line_item['quantity'].nil?
    return if @line_item['quantity'] == 0 # no negative quantities
    @line_item['quantity'] -= 1
  end

  def quantity
    @line_item['quantity']
  end

  def price
    @line_item['price']
  end

  def product_code
    @line_item['product_code']
  end

  def discount_total
    return if @line_item['discounts'].empty?
    @line_item['discounts'].last['discount_total']
  end

  def discount_point
    return if @line_item['discounts'].empty?
    @line_item['discounts'].last['discount_point']
  end

  def calculate_discounted_total(quantity, price, discount_point, discount_total)

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