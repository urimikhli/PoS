require './order'

describe Order do
  let(:price_list) {PriceList.new}
  let(:order) { Order.new(price_list) }
  subject {order}

  describe '.line_item' do
    it { is_expected.to respond_to :line_item }

    it 'should return nil when not found' do
      expect(order.line_item('A')).to be_nil
    end

    context 'return the line item if it is found' do
      before do
        order.add_item('A')
      end

      it 'should return a line item' do
        expect(order.line_item('A').class).to eq LineItem
      end

      it 'should return the line item we want' do
        expect(order.line_item('A').product_code).to eq 'A'
      end
    end

  end

  describe '.add_item' do
    it { is_expected.to respond_to :add_item }
    it 'should add an item hash to order array' do
      expect(order.order.count).to equal 0
    end
    context 'adding valid item' do
      before do
        order.add_item('A')
      end
      it 'should have an item in the order array' do
        expect(order.order.count).to equal 1
      end
      it 'should have item code A' do
        expect(order.order.first.product_code).to eq 'A'
      end
    end

    context 'adding invalid item' do
      before do
        order.add_item('Z')
      end
      it 'should not add to the order array' do
        expect(order.order.count).to equal 0
      end
    end
  end

  describe '.delete_item' do
    it { is_expected.to respond_to :delete_item }

    describe 'deleting A from ABAB should result in ABB' do
      before do
        order.add_item('A')
        order.add_item('B')
        order.add_item('A')
        order.add_item('B')

      end

      it 'should have 2 items A and B with quantity 2 each' do
        expect(order.order.count).to equal 2
        expect(order.line_item('A').quantity).to equal 2
        expect(order.line_item('B').quantity).to equal 2
      end

      context 'deleting a valid item A' do
        before do
          order.delete_item('A')
        end
        it 'should still have 2 line items A and B' do
          expect(order.order.count).to equal 2
        end
        it 'first (A) should have one less quantity ' do
          expect(order.order.first.quantity).to equal 1
        end
        it 'last (B) should still have two quantity ' do
          expect(order.order.last.quantity).to equal 2
        end
      end

      context 'deleting an invalid item' do
        before do
          order.delete_item('Z')
        end
        it 'should still have the same number of line_items' do
          expect(order.order.count).to equal 2
        end
        it 'should still have both A and B' do
          expect(order.line_item('A').product_code).to eq 'A'
          expect(order.line_item('B').product_code).to eq 'B'
        end

        it 'A and B should both be same quantity' do
          expect(order.line_item('A').quantity).to equal 2
          expect(order.line_item('B').quantity).to equal 2
        end
      end
    end
  end

  describe '.total' do
    it { is_expected.to respond_to :total }
    it 'should start with a total of' do
      expect(order.total).to equal 0
    end

    context 'adding an item to the order' do
      before do
        order.add_item('A')
      end
      it 'should total the price of A $2.00' do
        expect(order.total).to equal 2.00
      end
    end

    describe 'Volume pricing' do

      context 'adding ABCDABAA:' do
        before do
          order.add_item('A')
          order.add_item('B')
          order.add_item('C')
          order.add_item('D')
          order.add_item('A')
          order.add_item('B')
          order.add_item('A')
          order.add_item('A')
        end
        it 'should not charge full price' do
          expect(order.total).to_not equal 33.4
        end

        it 'should give volume discount' do
          expect(order.total).to equal 32.40
        end
      end
      context 'adding CCCCCCC:' do
        before do
          order.add_item('C')
          order.add_item('C')
          order.add_item('C')
          order.add_item('C')
          order.add_item('C')
          order.add_item('C')
          order.add_item('C')
        end
        it 'should not charge full price' do
          expect(order.total).to_not equal 8.75
        end

        it 'should give volume discount' do
          expect(order.total).to equal 7.25
        end
      end
      context 'adding ABCD:' do
        before do
          order.add_item('A')
          order.add_item('B')
          order.add_item('C')
          order.add_item('D')
        end
        it 'should charge full price' do
          expect(order.total).to equal 15.40
        end

      end

    end
  end

end