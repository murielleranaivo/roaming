require_relative '../utils'

class CurrencyConversion
  attr_accessor :exchange_rate_code, :number_of_decimal_places, :exchange_rate

  def initialize(exchange_rate_code, number_of_decimal_places, exchange_rate)
    @exchange_rate_code = exchange_rate_code
    @number_of_decimal_places = number_of_decimal_places
    @exchange_rate = exchange_rate
  end

  def self.from_map(map)
    exchange_rate_code = Utils.ascii_to_i(map[0][105])
    number_of_decimal_places = Utils.ascii_to_i(map[1][159])
    exchange_rate = Utils.ascii_to_i(map[2][104])
    new(exchange_rate_code, number_of_decimal_places, exchange_rate)
  end

  def as_json(options = {})
    {
      text: 'CurrencyConversion',
      children: [
        { text: "ExchangeRateCode: #{@exchange_rate_code}" },
        { text: "NumberOfDecimalPlaces: #{@number_of_decimal_places}" },
        { text: "ExchangeRate: #{@exchange_rate}" }
      ]

    }
  end

  def to_json(*options)
    as_json(*options).to_json(*options)
  end

end