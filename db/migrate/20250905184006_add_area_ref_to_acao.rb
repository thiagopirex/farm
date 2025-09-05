class AddAreaRefToAcao < ActiveRecord::Migration[8.0]
  def change
    add_reference :acaos, :area, index: true, foreign_key: true
  end
end
