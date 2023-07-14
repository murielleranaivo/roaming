require_relative 'timestamp'

class BatchControlInfo
  attr_accessor :sender, :recipient, :file_sequence_number, :file_creation_timestamp, :transfer_cutoff_timestamp, :file_available_timestamp, :specification_version_number, :release_version_number

  def initialize(sender, recipient, file_sequence_number, file_creation_timestamp, transfer_cutoff_timestamp, file_available_timestamp, specification_version_number, release_version_number)
    @sender = sender
    @recipient = recipient
    @file_sequence_number = file_sequence_number
    @file_creation_timestamp = file_creation_timestamp
    @transfer_cutoff_timestamp = transfer_cutoff_timestamp
    @file_available_timestamp = file_available_timestamp
    @specification_version_number = specification_version_number
    @release_version_number = release_version_number
  end

  def self.from_map(map)
    sender = map[0][196]
    recipient = map[1][182]
    file_sequence_number = map[2][109]
    file_creation_timestamp = Timestamp.from_map(map[3][108])
    transfer_cutoff_timestamp = Timestamp.from_map(map[4][227])
    file_available_timestamp = Timestamp.from_map(map[5][107])
    specification_version_number = Utils.ascii_to_i(map[6][201])
    release_version_number = Utils.ascii_to_i(map[7][189])
    new(sender, recipient, file_sequence_number, file_creation_timestamp, transfer_cutoff_timestamp, file_available_timestamp, specification_version_number, release_version_number)
  end

  def as_json(options = {})
    @file_creation_timestamp.text = 'FileCreationTimeStamp'
    @transfer_cutoff_timestamp.text = 'TransferCutoffTimeStamp'
    @file_available_timestamp.text = 'FileAvailableTimeStamp'
    {
      text: 'BatchControlInfo',
      children: [
        { text: "Sender: #{@sender}" },
        { text: "Recipient: #{@recipient}" },
        { text: "FileSequenceNumber: #{@file_sequence_number}" },
        @file_creation_timestamp,
        @transfer_cutoff_timestamp,
        @file_available_timestamp,
        { text: "SpecificationVersionNumber: #{@specification_version_number}" },
        { text: "ReleaseVersionNumber: #{@release_version_number}" }
      ]
    }
  end

  def to_json(*options)
    as_json(*options).to_json(*options)
  end

end