require './terminal'

describe Terminal do

  let(:terminal) { Terminal.new }

  it 'should have pricing model' do
    expect(terminal.price_list.is_a? PriceList).to be true
  end
  it 'should have an order' do
    expect(terminal.order.is_a? Order).to be true
  end

  describe '.set_pricing' do

    it { is_expected.to respond_to :set_pricing }
    it 'should use regular pricing' do
      expect(terminal.price_list.price("A")).to equal 2.00
    end
    context 'Changing the pricing model ' do
      before do
        terminal.set_pricing('holiday')
      end

      it 'should have a different price' do
        expect(terminal.price_list.price("A")).to equal 3.00
      end
    end

  end

  describe '.scan' do
    it { is_expected.to respond_to :scan }
    it 'should have no orders' do
      expect(terminal.order.order.count).to equal 0
    end

    context 'using scan adds the item to order' do
      before do
        terminal.scan('A')
      end
      it 'should have one order' do
        expect(terminal.order.order.count).to equal 1
      end
    end
  end

  describe '.remove' do
    it { is_expected.to respond_to :remove }
    describe 'removing A from ABAB should result in ABB' do
      before do
        terminal.scan('A')
        terminal.scan('B')
        terminal.scan('A')
        terminal.scan('B')

      end

      it 'should have 2 items AB' do
        expect(terminal.order.order.count).to equal 2
      end

      context 'deleting a valid item A' do
        before do
          terminal.remove('A')
        end
        it 'should still have 2 orders ABB' do
          expect(terminal.order.order.count).to equal 2
        end
        it 'first item should still be A and have a quantity of 1' do
          expect(terminal.order.order.first.quantity).to equal 1
        end
        it 'and last item should still be B and have a quantity of 2' do
          expect(terminal.order.order.last.quantity).to equal 2
        end
      end
      context 'deleting an invalid item' do
        before do
          terminal.remove('Z')
        end
        it 'should still have the same number of line items' do
          expect(terminal.order.order.count).to equal 2
        end
        it 'should still have the same quantity for A and B ' do
          expect(terminal.order.line_item('A').quantity).to equal 2
          expect(terminal.order.line_item('B').quantity).to equal 2
        end
      end
    end
  end
  describe '.total' do
    it { is_expected.to respond_to :total }
    it 'should start with a total of' do
      expect(terminal.total).to equal 0
    end

    context 'using scan adds the item to order' do
      before do
        terminal.scan('A')
      end
      it 'should total the price of A $2.00' do
        expect(terminal.total).to equal 2.00
      end
    end

    describe 'Volume pricing' do

      context 'scanning ABCDABAA:' do
        before do
          terminal.scan("A")
          terminal.scan("B")
          terminal.scan("C")
          terminal.scan("D")
          terminal.scan("A")
          terminal.scan("B")
          terminal.scan("A")
          terminal.scan("A")
        end
        it 'should not charge full price' do
          expect(terminal.total).to_not equal 33.4
        end

        it 'should give volume discount' do
          expect(terminal.total).to equal 32.40
        end
      end
      context 'scanning CCCCCCC:' do
        before do
          terminal.scan("C")
          terminal.scan("C")
          terminal.scan("C")
          terminal.scan("C")
          terminal.scan("C")
          terminal.scan("C")
          terminal.scan("C")
        end
        it 'should not charge full price' do
          expect(terminal.total).to_not equal 8.75
        end

        it 'should give volume discount' do
          expect(terminal.total).to equal 7.25
        end
      end
      context 'scanning ABCD:' do
        before do
          terminal.scan("A")
          terminal.scan("B")
          terminal.scan("C")
          terminal.scan("D")
        end
        it 'should charge full price' do
          expect(terminal.total).to equal 15.40
        end
      end

    end
  end

  describe '.new_order' do

    before do
      terminal.scan("A")
    end

    it { is_expected.to respond_to :new_order }

    it 'should have an order with regular total for product A' do
      expect(terminal.order.order.count).to equal 1
      expect(terminal.total).to equal 2.00
    end

    context 'Calling new_order creates a new order object' do
      before do
        terminal.new_order
      end
      it 'should show a different total ' do
        expect(terminal.order.order.count).to equal 0
        expect(terminal.total).to equal 0
      end
    end
  end


end

