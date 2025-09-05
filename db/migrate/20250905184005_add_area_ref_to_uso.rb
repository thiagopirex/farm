class AddAreaRefToUso < ActiveRecord::Migration[8.0]
  def change
    add_reference :usos, :area, index: true, foreign_key: true
  end
end
