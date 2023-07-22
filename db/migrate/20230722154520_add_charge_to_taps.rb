class AddChargeToTaps < ActiveRecord::Migration[7.0]
  def change
    add_column :taps, :total_charge, :integer
    add_column :taps, :total_tax, :integer
    add_column :taps, :total_discount, :integer
  end
end
