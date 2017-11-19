class AddAreaRefToUso < ActiveRecord::Migration[5.1]
  def change
    add_reference :usos, :area, index: true, foreign_key: true
  end
end
