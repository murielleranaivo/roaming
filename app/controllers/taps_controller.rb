require 'pp'

class TapsController < ApplicationController
  def index

    file_path = Rails.public_path.join('asn1_files', 'CDFRAF1MDGTM42711')
    file_exists = File.exist?(file_path)
    puts "file exists: #{file_exists}"

    transfer_batch = Asn1Decoder.decode_asn1_der(file_path)
    @transfer_batch_json = transfer_batch.to_json
  end
end
