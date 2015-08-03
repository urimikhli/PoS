require './order'

describe Order do
  let(:price_list) {PriceList.new}
  let(:order) { Order.new(price_list) }
  subject {order}

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

      it 'should have 4 items ABAB' do
        expect(order.order.count).to equal 4
      end

      context 'deleting a valid item A' do
        before do
          order.delete_item('A')
        end
        it 'should have 3 orders ABB' do
          expect(order.order.count).to equal 3
        end
        it 'first item should still be A ' do
          expect(order.order.first.product_code).to eq 'A'
        end
        it 'and last item should still be B' do
          expect(order.order.last.product_code).to eq 'B'
        end
      end
      context 'deleting an invalid item' do
        before do
          order.delete_item('Z')
        end
        it 'should still have the same number of orders' do
          expect(order.order.count).to equal 4
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