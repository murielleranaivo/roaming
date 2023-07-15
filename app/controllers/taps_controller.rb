require 'pp'

class TapsController < ApplicationController
  def index

    file_path = Rails.public_path.join('asn1_files', 'CDFRAF1MDGTM42711')
    file_exists = File.exist?(file_path)
    puts "file exists: #{file_exists}"

    @transfer_batch = Asn1Decoder.decode_asn1_der(file_path)

    @batch_control_info = @transfer_batch.batch_control_info
    @accounting_info = @transfer_batch.accounting_info
    @network_info = @transfer_batch.network_info
    @call_event_details = @transfer_batch.call_event_details
    @audit_control_info = @transfer_batch.audit_control_info

    @transfer_batch_json = @transfer_batch.to_json
  end
end
