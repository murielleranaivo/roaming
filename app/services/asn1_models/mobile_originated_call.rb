require_relative 'mobile_call'

class MobileOriginatedCall < MobileCall
  def initialize(basic_call_information, location_information, equipment_identifier, basic_service_used_list, operator_spec_information)
    super
    @text = "MobileOriginatedCall"
  end

end