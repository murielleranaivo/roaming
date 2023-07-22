class CreateCallDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :call_details do |t|
      t.string :imsi
      t.string :msisdn
      t.string :bnum
      t.string :call_timestamp
      t.integer :charge
      t.integer :charge_units

      t.timestamps
    end
  end
end
