require 'json'
require_relative 'record_search.rb'

class PriceList
  include RecordSearch
  attr_reader :pricing

  def initialize(file_name = './data/price_list.json') #set default, but give chane to give diff file
    set_price_list(file_name.to_s)
  end

  def set_price_list(file_name)
    @pricing = load_from_file(file_name)
  end

  def get_item(item_code)
    search(@pricing, "product_code", item_code).first
  end

  def price(item_code = "")
    return if item_code.empty?
    product = @pricing.select{|x|x["product_code"].downcase.eql?(item_code.downcase)}

    return if product.empty?
    product.last["price"]
  end

  private

  def load_from_file(file_name)
    JSON.parse(IO.read(file_name))
  end
end
