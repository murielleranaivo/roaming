class RenameRefTapsToTap < ActiveRecord::Migration[7.0]
  def change
    rename_column :call_details, :taps_id, :tap_id
  end
end
