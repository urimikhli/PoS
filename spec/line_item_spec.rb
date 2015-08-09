require 'rspec'
require './line_item'
require './product'

describe LineItem do
  let (:no_discount_product) {
    Product.new (
    {
        'product_code'=> 'B',
        'price'=> 12.00,
        'discounts'=> []
    } )

  }

  let(:product) {
    Product.new (
    {
        'product_code'=> 'A',
        'price'=> 2.00,
        'discounts'=> [
            {
                'discount_point'=> 4,
                'discount_total'=> 7.00
            }
        ]
    } )
  }
  let(:line_item_no_discount) {LineItem.new(no_discount_product)}
  let(:line_item) {LineItem.new(product)}
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

  describe '.item_total' do
    it { is_expected.to respond_to :item_total }

    it 'should total the price of A $2.00' do
      expect(line_item.item_total).to equal 2.00
    end

    describe 'Volume pricing for items that have discounts defined' do

      context 'adding quantity' do
        before do
          line_item.increment_quantity
          line_item.increment_quantity
        end

        it 'should charge full price' do
          expect(line_item.item_total).to equal 6.00
        end

        context 'hitting the discount point' do
          before do
            line_item.increment_quantity
          end

          it 'should not charge full price' do
            expect(line_item.item_total).to_not equal 8.00
          end

          it 'should give volume discount (pack price)' do
            expect(line_item.item_total).to equal 7.00
          end

          context 'adding items past discount point (pack) should be totaled at full price' do
            before do
              line_item.increment_quantity
              line_item.increment_quantity
              line_item.increment_quantity
            end

            it 'should charge full price for items past the discount point' do
              expect(line_item.item_total).to_not equal 12.25
            end

            it 'should should give discount to items at the discount point(pack) and full price for those that dont' do
              expect(line_item.item_total).to equal 13.00
            end

            context 'Hitting the pack point again' do
              before do
                line_item.increment_quantity
              end

              it 'should not charge full price' do
                expect(line_item.item_total).to_not equal 16.00
              end

              it 'should give volume discount (pack price)' do
                expect(line_item.item_total).to equal 14.00
              end
            end
          end
        end
      end

    end
    describe 'No volume pricing for items that have no discount point defined' do
      context 'adding quantity:' do
        before do
          line_item_no_discount.increment_quantity
          line_item_no_discount.increment_quantity
        end
        it 'should charge full price' do
          expect(line_item_no_discount.item_total).to equal 36.00
          expect(line_item_no_discount.discount_point).to be_nil
        end

      end
    end

  end


end