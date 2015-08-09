module RecordSearch
  VALID_SEARCH_FIELDS = %w(product_code)
  def validate_field(search_field = "")
    VALID_SEARCH_FIELDS.select { |x| x.downcase == search_field.downcase }.empty? ? false : true
  end

  def search(search_space, type, search_field, query_field)
    return unless validate_field search_field

    if type.eql? 'hash'
      hash_records_search(search_space, search_field, query_field)
    elsif type.eql? 'class'
      class_records_search(search_space, search_field, query_field)
    end

  end

  private
  def hash_records_search(search_space, search_field, query_field)
    search_space.select { |x| /#{query_field.downcase}/.match(x[search_field].downcase) }.sort_by { |hsh| hsh[search_field] }
  end

  def class_records_search(search_space, search_field, query_field)
    search_space.select { |x| /#{query_field}/.match(x.send search_field) }
  end


end
