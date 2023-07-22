class CreateTaps < ActiveRecord::Migration[7.0]
  def change
    create_table :taps do |t|
      t.string :name

      t.timestamps
    end
  end
end
