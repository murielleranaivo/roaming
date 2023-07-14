require_relative 'timestamp'
require_relative '../utils'

class AuditControlInfo
  attr_accessor :earliest_call_timestamp, :latest_call_timestamp, :total_charge, :total_tax_value, :total_discount_value, :call_event_details_count, :operator_spec_information

  def initialize(earliest_call_timestamp, latest_call_timestamp, total_charge, total_tax_value, total_discount_value, call_event_details_count, operator_spec_information)
    @earliest_call_timestamp = earliest_call_timestamp
    @latest_call_timestamp = latest_call_timestamp
    @total_charge = total_charge
    @total_tax_value = total_tax_value
    @total_discount_value = total_discount_value
    @call_event_details_count = call_event_details_count
    @operator_spec_information = operator_spec_information
  end

  def self.from_map(map)
    earliest_call_timestamp = Timestamp.from_map(map[0][101])
    latest_call_timestamp = Timestamp.from_map(map[1][133])
    total_charge = Utils.ascii_to_i(map[2][415])
    total_tax_value = Utils.ascii_to_i(map[3][226])
    total_discount_value = Utils.ascii_to_i(map[4][225])
    call_event_details_count = Utils.ascii_to_i(map[5][43])
    operator_spec_information = []
    map[6][162].each do |element|
      operator_spec_information.push(OperatorSpecInformation.new(element[163]))
    end
    new(earliest_call_timestamp, latest_call_timestamp, total_charge, total_tax_value, total_discount_value, call_event_details_count, operator_spec_information)
  end

  def as_json(options = {})
    @earliest_call_timestamp.text = "EarliestCallTimestamp"
    @latest_call_timestamp.text = "LatestCallTimestamp"
    {
      text: 'AuditControlInfo',
      children: [
        @earliest_call_timestamp,
        @latest_call_timestamp,
        { text: "TotalCharge: #{@total_charge}" },
        { text: "TotalTaxValue: #{@total_tax_value}" },
        { text: "TotalDiscountValue: #{@total_discount_value}" },
        { text: "CallEventDetailsCount: #{@call_event_details_count}" },
        {
          text: 'OperatorSpecInformation',
          children: @operator_spec_information
        }
      ]
    }
  end

  def to_json(*options)
    as_json(*options).to_json(*options)
  end

end