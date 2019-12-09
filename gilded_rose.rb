require 'ostruct'

class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      update_item(item)
    end
  end

  private

  ITEM_NAMES = OpenStruct.new(
    aged_brie: 'Aged Brie',
    backstage: 'Backstage passes to a TAFKAL80ETC concert',
    sulfuras: 'Sulfuras, Hand of Ragnaros',
    conjured: 'Conjured'
  ).freeze

  MIN_QUALITY = 0.freeze
  MAX_QUALITY = 50.freeze
  LEGENDARY_QUALITY = 80.freeze
  BACKSTAGE_BREAKPOINTS = [
    {sell_in: 5, quality_increment: 3},
    {sell_in: 10, quality_increment: 2}
  ].freeze

  def update_item(item)
    item.quality = calculate_new_quality(item)
    item.sell_in = calculate_new_sell_in(item)
  end

  def calculate_new_quality(item)
    return LEGENDARY_QUALITY if legendary_item?(item)
    if item.sell_in <= 0
      if item.name == ITEM_NAMES.backstage
        return 0
      elsif item.name == ITEM_NAMES.conjured
        return normalize_quality(item.quality - 4)
      elsif regular_item?(item)
        return normalize_quality(item.quality - 2)
      end
    end

    new_quality = nil

    if regular_item?(item)
      new_quality = item.quality - 1
    elsif item.name == ITEM_NAMES.conjured
      new_quality = item.quality - 2
    elsif item.name == ITEM_NAMES.aged_brie
      new_quality = item.quality + 1
    elsif item.name == ITEM_NAMES.backstage
      breakpoint = BACKSTAGE_BREAKPOINTS.find { |bp| item.sell_in <= bp[:sell_in] }
      quality_increment = breakpoint ? breakpoint[:quality_increment] : 1
      new_quality = item.quality + quality_increment
    end

    normalize_quality(new_quality)
  end

  def normalize_quality(new_quality)
    if new_quality < MIN_QUALITY
      MIN_QUALITY
    elsif new_quality > MAX_QUALITY
      MAX_QUALITY
    else
      new_quality
    end
  end

  def calculate_new_sell_in(item)
    return nil if unlimited_sell_in?(item)

    item.sell_in - 1
  end

  def regular_item?(item)
    !ITEM_NAMES.to_h.values.include?(item.name)
  end

  def unlimited_sell_in?(item)
    legendary_item?(item) || item.name == ITEM_NAMES.aged_brie
  end

  def legendary_item?(item)
    item.name == ITEM_NAMES.sulfuras
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
