class AddReceiptTextToCallDetails < ActiveRecord::Migration[7.0]
  def change
    add_column :call_details, :receipt_text, :string
  end
end
