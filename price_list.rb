require 'json'
require_relative 'record_search.rb'
require_relative 'product.rb'


class PriceList
  include RecordSearch
  attr_reader :pricing

  def initialize #set default, but give chane to give diff file
    @pricing = []
    set_price_list
  end

  def set_price_list(pricing_type = 'regular')
    load_price_list(pricing_type)
  end

  def get_item(item_code)
    search(@pricing, 'hash', "product_code", item_code).first
  end

  def get_product(product_code)
    search(@pricing, 'class', "product_code", product_code).first
  end

  private

  def load_price_list(pricing_type = 'regular')
    return if pricing_source(pricing_type).empty?
    @pricing = []
    load_from_file(pricing_source(pricing_type)).each do |product|
      @pricing.push Product.new(product) unless product.empty?
    end
  end

  def load_from_file(file_name)
    JSON.parse(IO.read(file_name))
  end

  def pricing_source(pricing_type = 'regular')
    {
        regular: './data/price_list.json',
        holiday: './data/holiday_price_list.json'
    }[pricing_type.to_sym]
  end

end
