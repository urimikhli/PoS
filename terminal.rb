require_relative 'order.rb'
class Terminal
  attr_reader :order, :price_list

  def initialize
    set_pricing # initialize as default, call set pricing to reassign: @order and @price_list = PriceList.new(some_file_name)
  end

  def pricing_source(pricing_type="regular")
    {
        regular: './data/price_list.json',
        holiday: './data/price_list.json'
    }[pricing_type.to_sym]
  end

  #new list and new order
  def set_pricing(pricing_type="regular")
    @price_list = PriceList.new(pricing_source(pricing_type))
    @order = Order.new(@price_list)
    #price_list
  end

  def scan(item_code = "")
    @order.add_item(item_code)

    puts 'scan: ' + item_code.to_s + ":price:" + @price_list.price(item_code).to_s

  end

  def total
    @order.total
  end

  def new_order
    @order = Order.new(@price_list)
  end

end
