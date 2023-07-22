class AddTapToCallDetails < ActiveRecord::Migration[7.0]
  def change
    add_reference :call_details, :taps, foreign_key: true
  end
end
