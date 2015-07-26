require_relative 'record_search.rb'
class PriceList
  include RecordSearch

  def initialize(file_name='./data/price_list.json') #set default, but give chane to give diff file
    @pricing = set_price_list(filename)
  end

  def set_price_list(filename)
    'The price list'
    #read file
    # jason array
    []
  end

  def price(item_code)
    get_price(item_code, quantity)
  end

  def discount_point
    #
  end

  def discount_price
    #
  end

  private

  def get_price(item_code, quantity)
    if item = search_inventory(item_code, "product_code")
    end
  end

end
