require_relative 'price_list.rb'
require_relative 'line_item.rb'


class Order
  include RecordSearch
  attr_reader :order

  def initialize(price_list)
    @order= []
    @price_list ||= price_list
  end

  def add_item(item_code)
    #
    item = @price_list.get_item(item_code)

    unless item.nil?
      line_item = get_line_item(item_code)
      if line_item.nil?
        @order << LineItem.new(item)
      else
        line_item.increment_quantity
      end
    else
      puts 'NO ITEM FOUND'
    end
  end

  def delete_item(item_code)
    line_item = get_line_item(item_code)
    return if line_item.nil?
    return if line_item.quantity.nil?

    line_item.decrement_quantity
    @order.delete line_item if line_item.quantity == 0
  end

  def line_item(item_code)
    get_line_item(item_code)
  end

  def total
    order_total ||= get_order_total
  end

  private

  def get_order_total
    #
    total = 0

    #products = @order.map {|x| x.product_code}.uniq

    @order.each do |line_item|
      #line_items = get_line_items(line_item)
      #quantity = line_items.count
      quantity = line_item.quantity
      discount_point = line_item.discount_point
      price = line_item.price
      discount_total = line_item.discount_total
      #price = line_items.first.price

      #discount = line_items.first['discounts']

      #local_total = calculate_discount_pricing(discount, quantity, price)

      total += line_item.calculate_discounted_total(quantity, price, discount_point, discount_total)
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

    #lookup grep for this
    @order.select {|x| x.product_code.eql?(product_code)}.last
  end

end
