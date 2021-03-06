require_relative 'price_list.rb'
require_relative 'line_item.rb'


class Order
  include RecordSearch
  attr_reader :order

  def initialize(price_list)
    @order= []
    @price_list ||= price_list
  end

  def line_item(item_code)
    get_line_item(item_code)
  end

  def add_item(product_code)
    #
    product = @price_list.get_product(product_code)

    unless product.nil?
      line_item = self.line_item(product_code)
      if line_item.nil?
        @order << LineItem.new(product)
      else
        line_item.increment_quantity
      end
    else
      puts 'NO ITEM FOUND'
    end
  end

  def delete_item(item_code)
    line_item = self.line_item(item_code)
    return if line_item.nil?
    return if line_item.quantity.nil?

    line_item.decrement_quantity
    @order.delete line_item if line_item.quantity == 0
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
      total += line_item.item_total
    end

    total
  end

  def get_line_item(product_code = '')
    return if product_code.empty?

    return if @order.empty?

    #lookup grep for this
    @order.select {|x| x.product_code.eql?(product_code)}.last
  end

end
