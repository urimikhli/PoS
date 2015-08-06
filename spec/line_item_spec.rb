require 'rspec'
require './line_item'

describe 'LineItem' do
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
  let(:line_item_no_discount) {LineItem.new(no_discount_item_hash)}
  let(:line_item) {LineItem.new(item_hash)}
  subject {line_item}

  it 'should have a quantity of 1' do
    expect(line_item.line_item[:quantity]).to equal 1
  end

  describe '.quantity' do
    it { is_expected.to respond_to :quantity }
    before do
      line_item.line_item[:quantity] = 4
    end

    it 'should return the correct line item quantity' do
      expect(line_item.quantity).to equal 4
    end
  end

  describe '.increment_quantity ' do
    it { is_expected.to respond_to :increment_quantity }
    context 'increment_quantity adds one to the quantity' do
      before do
        line_item.increment_quantity
      end
      it 'should have a quantity of 2' do
        expect(line_item.line_item[:quantity]).to equal 2
      end
    end
  end

  describe '.decrement_quantity ' do
    it { is_expected.to respond_to :increment_quantity }
    before do
      line_item.increment_quantity
    end
    it 'before decrementing it should have a quantity of 2' do
      expect(line_item.line_item[:quantity]).to equal 2
    end
    context 'decrement_quantity removes one one from the quantity' do
      before do
        line_item.decrement_quantity
      end
      it 'should have a quantity of 1' do
        expect(line_item.line_item[:quantity]).to equal 1
      end
      context 'decrementing to 0 should set quantity to 0' do
        before do
          line_item.decrement_quantity
        end
        it 'should have a quantity of 0' do
          expect(line_item.line_item[:quantity]).to equal 0
        end
        context 'decrementing below 0 should not change quantity' do
          before do
            line_item.decrement_quantity
          end
          it 'should have a quantity of 0' do
            expect(line_item.line_item[:quantity]).to equal 0
          end
        end
      end
    end
  end

  describe '.price' do
    it { is_expected.to respond_to :price }

    it 'should return the correct line item price' do
      expect(line_item.price).to equal 2.00
    end
  end

  describe '.product_code' do
    it { is_expected.to respond_to :product_code }

    it 'should return the correct line item price' do
      expect(line_item.product_code).to eq 'A'
    end
  end

  describe '.discount_total' do
    it { is_expected.to respond_to :discount_total }

    it 'should return the discount total' do
      expect(line_item.discount_total).to eq 7.00
    end

     it 'if there is no discount pricing then it should return nil for discount_total' do
      expect(line_item_no_discount.discount_total).to be_nil
     end
  end

  describe '.discount_point' do
    it { is_expected.to respond_to :discount_point }

    it 'should return the discount point' do
      expect(line_item.discount_point).to eq 4
    end

    it 'if there is no discount pricing then it should return nil for discount_point' do
      expect(line_item_no_discount.discount_point).to be_nil
    end
  end



end