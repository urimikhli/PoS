require_relative 'order.rb'
class Terminal
  attr_reader :order, :price_list

  def initialize
    @price_list = PriceList.new
    @order = Order.new(@price_list)
  end

  #new list and new order
  def set_pricing(pricing_type='regular')
    @price_list.set_price_list(pricing_type)
    @order = Order.new(@price_list)
    #price_list
  end

  def scan(item_code = '')
    @order.add_item(item_code)

    #puts 'scan: ' + item_code.to_s + ':price:' + @price_list.price(item_code).to_s

  end

  def remove(item_code = '')
    @order.delete_item(item_code)
  end

  def total
    @order.total
  end

  def new_order
    @order = Order.new(@price_list)
  end

end
