require './terminal'

describe Terminal do

  let(:terminal) { Terminal.new }

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

  describe ''

end

