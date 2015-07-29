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

