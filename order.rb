require_relative 'price_list.rb' # PoS Terminal

class Order
  def initialize(price_list)
    @price_list ||= price_list
  end
  def add_item(item_code)
    #
    price = @price_list.price(item_code)
  end
  def total
    #
  end
end