require './price_list'

describe PriceList do

  let(:price_list) { PriceList.new }
  it 'should have pricing model' do
    expect(price_list.pricing.first.keys.first).to eq "product_code"
  end

  describe '.set_price_list' do
    it { is_expected.to respond_to :set_price_list }
    it 'should use regular pricing' do
      expect(price_list.pricing.first["price"]).to equal 2.00
    end
    context 'Calling set_price_list to Change the pricing model ' do
      before do
        price_list.set_price_list('./data/holiday_price_list.json')
      end

      it 'should have a different price ' do
        expect(price_list.pricing.first["price"]).to equal 3.00
      end
    end
  end

  describe '.get_item' do
    it { is_expected.to respond_to :get_item }

    it 'should return the requested item hash ' do
      expect(price_list.get_item("A")).to equal price_list.pricing.first
    end
  end

  describe '.price' do
    it { is_expected.to respond_to :price }

    it 'should return the requested item price ' do
      expect(price_list.price('A')).to equal price_list.pricing.first['price']
    end
  end

end