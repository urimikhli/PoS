require_relative 'price_list.rb'

class Order
  attr_reader :order

  def initialize(price_list)
    @order= []
    @price_list ||= price_list
  end

  def add_item(item_code)
    #
    item = @price_list.get_item(item_code)
    unless item.empty?
      @order << item.last
    else
      puts 'NO ITEM FOUND'
    end
  end

  def total
    order_total ||= get_order_total
  end

  private

  def get_order_total
    #
    total = 0

    products = @order.map {|x| x['product_code']}.uniq

    products.each do |product|
      line_items = @order.select{|x|x['product_code'].eql?(product)}
      quantity = line_items.count
      price = line_items.first['price']

      discount = line_items.first['discounts']

      local_total = calculate_discount_pricing(discount, quantity, price)

      total += local_total
    end

    total
  end

  def calculate_discount_pricing(discount, quantity, price)
    return price * quantity if discount.empty?
    discount_point =  discount.last['discount_point'].to_i
    remainder = quantity % discount_point

    if quantity < discount_point
      price * quantity  #regular price
    elsif discount_point == quantity
      #apply discount
      discount.last['discount_total']
    else
      times_discount_applied = (quantity - remainder) / discount_point#e.g.  17%3 -- qty:17 discount_point:3 -- remainder:2 --> (17 -2) / 3 =  5 times the discount was applied
      discount.last['discount_total'] * times_discount_applied  +  ( price * remainder )   #too simple for recursion: calculate_discount(discount, remainder, price)
    end
  end

  def get_line_item(product_code = '')
    return if product_code.empty?

    return if @order.empty?

    product_items = @order.select {|x| x['product_code'].eql?(product_code)}
    return if product_items.empty?

    product_items.last
  end

end
