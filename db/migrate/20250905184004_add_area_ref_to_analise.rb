class AddAreaRefToAnalise < ActiveRecord::Migration[8.0]
  def change
    add_reference :analises, :area, index: true, foreign_key: true
  end
end
