require_relative '../utils'

class EquipmentIdentifier
  attr_accessor :imei

  def initialize(imei)
    @imei = imei
  end

  def self.from_map(map)
    imei = Utils.ascii_to_s(map[0][128])
    new(imei)
  end

  def as_json(options = {})
    {
      imei: @imei
    }
  end

  def to_json(*options)
    as_json(*options).to_json(*options)
  end

end