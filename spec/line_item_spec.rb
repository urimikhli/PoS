require 'rspec'
require './line_item'

describe 'LineItem' do
  let(:item_hash) {
    {
        product_code: 'A',
        price: 2.00,
        discounts: [
            {
                discount_point: 4,
                discount_total: 7.00
            }
        ]
    }
  }
  let(:line_item) {LineItem.new(item_hash)}
  subject {line_item}

  it 'should have a quantity of 1' do
    expect(line_item.line_item['quantity']).to equal 1
  end

  describe '.increment_quantity ' do
    it { is_expected.to respond_to :increment_quantity }
    context 'increment_quantity adds one to the quantity' do
      before do
        line_item.increment_quantity
      end
      it 'should have a quantity of 2' do
        expect(line_item.line_item['quantity']).to equal 2
      end
    end
  end
  describe '.decrement_quantity ' do
    it { is_expected.to respond_to :increment_quantity }
    before do
      line_item.increment_quantity
    end
    it 'before decrementing it should have a quantity of 2' do
      expect(line_item.line_item['quantity']).to equal 2
    end
    context 'decrement_quantity removes one one from the quantity' do
      before do
        line_item.decrement_quantity
      end
      it 'should have a quantity of 1' do
        expect(line_item.line_item['quantity']).to equal 1
      end

    end
  end
end