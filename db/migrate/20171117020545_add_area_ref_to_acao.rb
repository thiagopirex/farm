class AddAreaRefToAcao < ActiveRecord::Migration[5.1]
  def change
    add_reference :acaos, :area, index: true, foreign_key: true
  end
end
