module RecordSearch
  VALID_SEARCH_FIELDS = %w(item_code)
  def validate_field(search_field = "")
    VALIDSEARCHFIELDS.select { |x| x.downcase == search_field.downcase }.empty? ? false : true
  end

  def records_search(search_field, query_field)
    @pricing.select { |x| /#{query_field.downcase}/.match(x[search_field].downcase) }.sort_by { |hsh| hsh[search_field] }
  end

  def search_inventory(search_field, query_field)
    return unless validate_field search_field
    records_search(search_field, query_field)
  end
end
