class AddAreaRefToAnalise < ActiveRecord::Migration[5.1]
  def change
    add_reference :analises, :area, index: true, foreign_key: true
  end
end
