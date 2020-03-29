class GildedRose
  attr_reader :name, :days_remaining, :quality

  def initialize(name:, days_remaining:, quality:)
    @name = name
    @days_remaining = days_remaining
    @quality = quality
  end

  def tick
    item = get_item_class.new(@quality, @days_remaining)
    item.tick
    @days_remaining = item.days_remaining
    @quality = item.quality
  end

  def get_item_class
    if  @name == 'Normal Item'
      NormalItem
    else
      GildedRose.const_get(
        @name
          .gsub(' ', '_')
          .gsub(',', '_')
          .split('_')
          .collect(&:capitalize)
          .join
          .+('Item')
      )
    end
  end

  class NormalItem
    attr_reader :quality, :days_remaining

    def initialize quality, days_remaining
      @quality = quality
      @days_remaining = days_remaining
    end

    def tick
      decrease_quality
      @days_remaining -= 1
      if @days_remaining < 0
        decrease_quality
      end
    end

    private

    def decrease_quality
      @quality = @quality - 1 if @quality > 0
    end
  end

  class SulfurasHandOfRagnarosItem < NormalItem
    def tick
    end
  end

  class BackstagePassesToATafkal80etcConcertItem < NormalItem
    def tick
      increase_quality
      @days_remaining -= 1
      if @days_remaining < 0
        decrease_quality
      end
    end

    private

    def decrease_quality
      destroy if @days_remaining < 0
    end

    def increase_quality
      if @quality < 50 
        @quality += 1
        if @days_remaining < 11
          @quality += 1
        end
        if @days_remaining < 6
          @quality += 1
        end
      end
    end

    def destroy
      @quality = 0
    end
  end

  class AgedBrieItem < NormalItem
    def tick
      increase_quality
      @days_remaining -= 1
      if @days_remaining < 0
        increase_quality
      end
    end

    private

    def increase_quality
      @quality += 1 if @quality < 50
    end
  end

  class ConjuredManaCakeItem < NormalItem
    def tick
      decrease_quality
      decrease_quality
      @days_remaining -= 1
      if @days_remaining < 0
        decrease_quality
        decrease_quality
      end
    end
  end
end
