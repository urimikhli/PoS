require_relative 'price_list.rb'

class Order

  def initialize(price_list)
    @price_list ||= price_list
  end

  def add_item(item_code)
    #
    item = @price_list.get_item(item_code)
    unless item.empty?
      @orders << item.last
    else
      "NO ITEM FOUND"
    end
  end

  def total
    #
  end
end
