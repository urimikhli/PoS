require './price_list'

describe PriceList do

  let(:price_list) { PriceList.new }

  it 'should have pricing model' do
    expect(price_list.pricing.count).to be > 0
  end

  describe '.set_price_list' do
    it { is_expected.to respond_to :set_price_list }

    it 'should have the correct first product (A)' do
      expect(price_list.pricing.first.product_code).to eq 'A'
    end

    it 'should use regular pricing' do
      expect(price_list.pricing.first.price).to equal 2.00
    end

    context 'Calling set_price_list to Change the pricing model ' do
      before do
        price_list.set_price_list('holiday')
      end

      it 'should have the correct first product (A)' do
        expect(price_list.pricing.first.product_code).to eq 'A'
      end

      it 'should have a different price ' do
        expect(price_list.pricing.first.price).to equal 3.00
      end
    end
  end

  describe '.get_product' do
    it { is_expected.to respond_to :get_item }

    it 'should return the requested product ' do
      expect(price_list.get_product('A')).to equal price_list.pricing.first
    end
    it 'should return empty array if product is not in pricing ' do
      expect(price_list.get_product('Z')).to be_nil
    end
  end

  describe '.price' do
    it { is_expected.to respond_to :price }

    it 'should return the requested item price ' do
      expect(price_list.price('A')).to equal price_list.pricing.first['price']
    end
  end

end