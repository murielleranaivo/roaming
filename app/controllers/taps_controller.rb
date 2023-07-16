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

    items = [
      ["<b>Communications</b>", "<b>Montant SDR</b>", "<b>Montant Ariary TTC</b>"]
    ]

    @call_event_details.each do |call_event_detail|
      call_event_detail.basic_service_used_list.each do |basic_service_used|
        basic_service_used.charge_information_list.each do |charge_information|
          total_charge = 0
          charge_information.charge_detail_list.each do |charge_detail|
            total_charge += charge_detail.charge.to_i
          end
          items << [call_event_detail.receipt_text, to_sdr(total_charge).to_s, to_ariary_ttc(total_charge)]
        end
      end
    end

    sdr_stock = * 0.00001
    items << ["Total", to_sdr(@audit_control_info.total_charge), to_ariary_ttc(@audit_control_info.total_charge)]
    items << ["<b>Autres frais divers</b>", nil, nil]
    items << ["Taxe(s)", to_sdr(@audit_control_info.total_tax_value), to_ariary_ttc(@audit_control_info.total_tax_value)]
    items << ["Total", to_sdr(@audit_control_info.total_tax_value), to_ariary_ttc(@audit_control_info.total_tax_value)]
    items << ["<b>Remise(s)</b>", nil, nil]
    items << %W[Réductions -#{to_sdr(@audit_control_info.total_discount_value)} -#{to_ariary_ttc(@audit_control_info.total_discount_value)}]
    items << %W[Total -#{to_sdr(@audit_control_info.total_discount_value)} -#{to_ariary_ttc(@audit_control_info.total_discount_value)}]
    items << ["<b>Somme à payer (Toutes taxes et droits compris)</b>",
              "<b>#{to_sdr((@audit_control_info.total_charge + @audit_control_info.total_tax_value - @audit_control_info.total_discount_value))}</b>",
              "<b>#{to_ariary_ttc((@audit_control_info.total_charge + @audit_control_info.total_tax_value - @audit_control_info.total_discount_value))}</b>"]

    r = Receipts::Receipt.new(
      details: [
        %w[NIF 3000003944],
        %w[STAT 61101111995000180],
        ["Date d'édition", Date.today],
      ],
      company: {
        name: "TELMA",
        address: "Zone Galaxy Andraharo Antananarivo 101 - Madagascar",
        email: "service.client@telma.mg",
        logo: helpers.image_url("Telma-logo.jpg")
      },
      recipient: [
        "Customer",
        "Their Address",
        "City, State Zipcode",
        nil,
        "customer@example.org"
      ],
      line_items: items,
      footer: "Merci pour votre collaboration!"
    )

    # Writes the PDF to disk
    r.render_file "receipt.pdf"

  end

  private

  def to_sdr(amount)
    total = amount * 0.00001

    total.floor(5)
  end

  def to_ariary_ttc(amount)
    sdr_ariary_change = 5000
    total = to_sdr(amount) * sdr_ariary_change

    total.floor(2).to_s
  end

end
