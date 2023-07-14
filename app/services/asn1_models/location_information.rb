require_relative 'network_location'

class LocationInformation
  attr_accessor :network_location

  def initialize(network_location)
    @network_location = network_location
  end

  def self.from_map(map)
    network_location = NetworkLocation.from_map(map[0][156])
    new(network_location)
  end

  def as_json(options = {})
    {
      network_location: @network_location
    }
  end

  def to_json(*options)
    as_json(*options).to_json(*options)
  end

end