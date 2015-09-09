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
    old_order_items = self.order.order.clone
    status = @order.add_item(item_code)

    {
        before: old_order_items,
        after: self.order.order
        #status: status
    }
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
