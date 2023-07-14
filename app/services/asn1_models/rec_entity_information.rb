require_relative '../utils'

class RecEntityInformation
  attr_accessor :rec_entity_code, :rec_entity_type, :rec_entity_id

  def initialize(rec_entity_code, rec_entity_type, rec_entity_id)
    @rec_entity_code = rec_entity_code
    @rec_entity_type = rec_entity_type
    @rec_entity_id = rec_entity_id
  end

  def self.from_map(map)
    rec_entity_code = Utils.ascii_to_i(map[0][184])
    rec_entity_type = Utils.ascii_to_i(map[1][186])
    rec_entity_id = map[2][400]
    new(rec_entity_code, rec_entity_type, rec_entity_id)
  end

  def as_json(options = {})
    {
      text: 'RecEntityInformation',
      children: [
        { text: "RecEntityCode: #{@rec_entity_code}" },
        { text: "RecEntityType: #{@rec_entity_type}" },
        { text: "RecEntityId: #{@rec_entity_id}" }
      ]

    }
  end

  def to_json(*options)
    as_json(*options).to_json(*options)
  end

end