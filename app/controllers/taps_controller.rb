require 'pp'

class TapsController < ApplicationController
  include ActiveStorage::SetCurrent

  def index
    @tap = Tap.new
  end

  def upload
    @tap = Tap.create(tap_params)
    redirect_to action: 'decode', id: @tap.id
  end

  def decode

    @tap = Tap.find(params[:id])
    der_data = @tap.file.download
    puts der_data

    @transfer_batch = Asn1Decoder.decode_asn1_der(der_data)

    @batch_control_info = @transfer_batch.batch_control_info
    @accounting_info = @transfer_batch.accounting_info
    @network_info = @transfer_batch.network_info
    @call_event_details = @transfer_batch.call_event_details
    @audit_control_info = @transfer_batch.audit_control_info

    @transfer_batch_json = @transfer_batch.to_json

    call_details = []
    @call_event_details.each do |call_event_detail|
      call_detail = CallDetail.new

      chargeable_subscriber = call_event_detail.basic_call_information.chargeable_subscriber.last
      call_detail.imsi = chargeable_subscriber.imsi
      call_detail.msisdn = chargeable_subscriber.msisdn

      unless call_event_detail.basic_call_information.call_originator.nil?
        call_originator = call_event_detail.basic_call_information.call_originator
        call_detail.bnum = call_originator.calling_number
      end

      unless call_event_detail.basic_call_information.destination.nil?
        destination = call_event_detail.basic_call_information.destination
        call_detail.bnum = destination.called_number
      end

      call_event_start_timestamp = call_event_detail.basic_call_information.call_event_start_timestamp
      call_detail.call_timestamp = call_event_start_timestamp.local_timestamp

      total_charge = 0
      charge_units = 0
      call_event_detail.basic_service_used_list.each do |basic_service_used|
        basic_service_used.charge_information_list.each do |charge_information|
          charge_information.charge_detail_list.each do |charge_detail|
            total_charge += charge_detail.charge.to_i
            charge_units += charge_detail.charged_units.to_i
          end
        end
      end
      call_detail.charge = total_charge
      call_detail.charge_units = charge_units

      call_details << call_detail
    end

    @tap.call_details = call_details
    
    @tap.total_charge = @audit_control_info.total_charge
    @tap.total_discount = @audit_control_info.total_discount_value
    @tap.total_tax = @audit_control_info.total_tax_value

    @tap.save

  end

  def receipt
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

  def tap_params
    params.require(:tap).permit(:id, :name, :file)
  end

end
