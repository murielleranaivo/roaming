require 'openssl'
require_relative 'asn1_models/transfer_batch'

class Asn1Decoder

  def self.decode_asn1_der(data)
    # Read the contents of the DER file
    # der_data = File.read(file_path)

    # Create an OpenSSL ASN1::DER object from the DER data
    asn1 = OpenSSL::ASN1.decode(data)

    # Traverse the ASN.1 structure and convert to JSON
    values = asn1_to_map(asn1)

    # Print the JSON representation
    transfer_batch = TransferBatch.from_map(values[1])

    transfer_batch
  end

  def self.asn1_to_map(asn1_data)
    if asn1_data.is_a?(OpenSSL::ASN1::ASN1Data)
      if asn1_data.value.is_a?(Array)
        elements = asn1_data.value.map { |element| asn1_to_map(element) }
        { asn1_data.tag => elements }
      else
        { asn1_data.tag => asn1_data.value }
      end
    else
      nil
    end
  end

end

# Provide the path to your ASN.1 DER file
# file_path = './CDFRAF1MDGTM42711'

# Call the decode_asn1_der method with the file path
# decode_asn1_der(file_path)