require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do
  context '#update_quality' do
    it 'does not change the name' do
      items = [Item.new('foo', 0, 0)]
      GildedRose.new(items).update_quality
      expect(items[0].name).to eq 'foo'
    end

    context 'for regular item' do
      it 'with non-zero quality and non-zero sell_in' do
        items = [Item.new('foo', 20, 30)]
        GildedRose.new(items).update_quality
        expect(items[0].sell_in).to eq(19)
        expect(items[0].quality).to eq(29)
      end

      it 'with zero quality' do
        items = [Item.new('foo', 20, 0)]
        GildedRose.new(items).update_quality
        expect(items[0].sell_in).to eq(19)
        expect(items[0].quality).to eq(0)
      end

      context 'with sell_in <= 0' do
        it do
          items = [Item.new('foo', 0, 30)]
          GildedRose.new(items).update_quality
          expect(items[0].sell_in).to eq(-1)
          expect(items[0].quality).to eq(28)
        end

        it do
          items = [Item.new('foo', -5, 10)]
          GildedRose.new(items).update_quality
          expect(items[0].sell_in).to eq(-6)
          expect(items[0].quality).to eq(8)
        end
      end
    end

    context 'for "Aged Brie"' do
      it 'with non-max quality' do
        items = [Item.new('Aged Brie', 0, 30)]
        GildedRose.new(items).update_quality
        expect(items[0].sell_in).to eq(nil)
        expect(items[0].quality).to eq(31)
      end

      it 'with max quality' do
        items = [Item.new('Aged Brie', 0, 50)]
        GildedRose.new(items).update_quality
        expect(items[0].sell_in).to eq(nil)
        expect(items[0].quality).to eq(50)
      end
    end

    context 'for "Backstage passes"' do
      it 'with sell_in > 10' do
        items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 11, 30)]
        GildedRose.new(items).update_quality
        expect(items[0].sell_in).to eq(10)
        expect(items[0].quality).to eq(31)
      end

      context 'with sell_in between 6 and 10' do
        it do
          items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 10, 30)]
          GildedRose.new(items).update_quality
          expect(items[0].sell_in).to eq(9)
          expect(items[0].quality).to eq(32)
        end

        it do
          items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 6, 30)]
          GildedRose.new(items).update_quality
          expect(items[0].sell_in).to eq(5)
          expect(items[0].quality).to eq(32)
        end
      end

      context 'with sell_in between 1 and 5' do
        it do
          items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 1, 30)]
          GildedRose.new(items).update_quality
          expect(items[0].sell_in).to eq(0)
          expect(items[0].quality).to eq(33)
        end

        it do
          items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 5, 30)]
          GildedRose.new(items).update_quality
          expect(items[0].sell_in).to eq(4)
          expect(items[0].quality).to eq(33)
        end
      end

      context 'with zero sell_in' do
        it do
          items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 0, 30)]
          GildedRose.new(items).update_quality
          expect(items[0].sell_in).to eq(-1)
          expect(items[0].quality).to eq(0)
        end

        it do
          items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 0, 50)]
          GildedRose.new(items).update_quality
          expect(items[0].sell_in).to eq(-1)
          expect(items[0].quality).to eq(0)
        end
      end

      it 'with max quality' do
        items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 10, 50)]
        GildedRose.new(items).update_quality
        expect(items[0].sell_in).to eq(9)
        expect(items[0].quality).to eq(50)
      end
    end

    context 'for "Sulfuras"' do
      context 'with any initial quality and sell_in' do
        it do
          items = [Item.new('Sulfuras, Hand of Ragnaros', 20, 30)]
          GildedRose.new(items).update_quality
          expect(items[0].sell_in).to eq(nil)
          expect(items[0].quality).to eq(80)
        end

        it do
          items = [Item.new('Sulfuras, Hand of Ragnaros', 20, 0)]
          GildedRose.new(items).update_quality
          expect(items[0].sell_in).to eq(nil)
          expect(items[0].quality).to eq(80)
        end

        it do
          items = [Item.new('Sulfuras, Hand of Ragnaros', 0, 30)]
          GildedRose.new(items).update_quality
          expect(items[0].sell_in).to eq(nil)
          expect(items[0].quality).to eq(80)
        end
      end
    end

    context 'for "Conjured"' do
      it 'with non-zero quality and non-zero sell_in' do
        items = [Item.new('Conjured', 20, 30)]
        GildedRose.new(items).update_quality
        expect(items[0].sell_in).to eq(19)
        expect(items[0].quality).to eq(28)
      end

      it 'with zero quality' do
        items = [Item.new('Conjured', 20, 0)]
        GildedRose.new(items).update_quality
        expect(items[0].sell_in).to eq(19)
        expect(items[0].quality).to eq(0)
      end

      context 'with zero sell_in' do
        it do
          items = [Item.new('Conjured', 0, 30)]
          GildedRose.new(items).update_quality
          expect(items[0].sell_in).to eq(-1)
          expect(items[0].quality).to eq(26)
        end

        it do
          items = [Item.new('Conjured', 0, 50)]
          GildedRose.new(items).update_quality
          expect(items[0].sell_in).to eq(-1)
          expect(items[0].quality).to eq(46)
        end
      end
    end
  end
end
