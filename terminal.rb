require_relative 'order.rb'
class Terminal
  attr_accessor :price_list, :order

  def initialize
    set_pricing # initialize as default, call set pricing to reassign: @order and @price_list = PriceList.new(some_file_name)
  end

  #new list and new order
  def set_pricing(price_list = PriceList.new)
    @price_list = price_list
    @order = Order.new(price_list)
    #price_list
  end

  def scan(item_code = "")
    @order.add_item(item_code)

    puts 'scan: ' + item_code.to_s + ":price:" + @price_list.price(item_code).to_s

  end
  def total
    @order.total
  end

end
