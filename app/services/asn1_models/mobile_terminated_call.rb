require_relative 'mobile_call'

class MobileTerminatedCall < MobileCall
  def initialize(basic_call_information, location_information, equipment_identifier, basic_service_used_list, operator_spec_information)
    super
    @text = "MobileTerminatedCall"
    @receipt_text = "Appel entrant"
  end

end