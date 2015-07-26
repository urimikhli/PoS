require_relative 'record_search.rb'
class PriceList
  include RecordSearch

  def initialize(file_name='./data/price_list.json') #set default, but give chane to give diff file
    @pricing = set_price_list(file_name)
  end

  def set_price_list(file_name)
    load_from_file(file_name)
  end
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
  def load_from_file(file_name)
    JSON.parse(IO.read(file_name))
  end
end
