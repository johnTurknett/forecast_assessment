class Lookup < ApplicationRecord
  store :data, accessors: [:temperature, :temperature_unit], coder: JSON

  validates :zipcode, presence: true, numericality: { only_integer: true }, length: { is: 5 }

  def cached
    if lookup_id
      @cached ||= Lookup.find(lookup_id)
    end
  end

  def low
    return cached.temperature[:low] if cached
    return "" unless temperature

    temperature[:low]
  end

  def high
    return cached.temperature[:high] if cached
    return "" unless temperature

    temperature[:high]
  end

  def current
    return cached.temperature[:current] if cached
    return "" unless temperature

    temperature[:current]
  end

  def unit
    return cached.temperature_unit if cached

    temperature_unit
  end
end
