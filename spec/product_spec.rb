require 'rspec'
require './product'

describe Product do
  let (:no_discount_item_hash) {
    {
        'product_code'=> 'B',
        'price'=> 12.00,
        'discounts'=> []
    }

  }

  let(:item_hash) {
    {
        'product_code'=> 'A',
        'price'=> 2.00,
        'discounts'=> [
            {
                'discount_point'=> 4,
                'discount_total'=> 7.00
            }
        ]
    }
  }

  let(:product_no_discount) {Product.new(no_discount_item_hash)}
  let(:product) {Product.new(item_hash)}
  subject {product}

  describe '.product_code' do
    it { is_expected.to respond_to :product_code }

    it 'should return the correct line item price' do
      expect(product.product_code).to eq 'A'
    end
  end

  describe '.price' do
    it { is_expected.to respond_to :price }

    it 'should return the correct line item price' do
      expect(product.price).to equal 2.00
    end
  end

  describe '.discount_total' do
    it { is_expected.to respond_to :discount_total }

    it 'should return the discount total' do
      expect(product.discount_total).to eq 7.00
    end

    it 'if there is no discount pricing then it should return nil for discount_total' do
      expect(product_no_discount.discount_total).to be_nil
    end
  end

  describe '.discount_point' do
    it { is_expected.to respond_to :discount_point }

    it 'should return the discount point' do
      expect(product.discount_point).to eq 4
    end

    it 'if there is no discount pricing then it should return nil for discount_point' do
      expect(product_no_discount.discount_point).to be_nil
    end
  end

end