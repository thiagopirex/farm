class AddPropriedadeRefToArea < ActiveRecord::Migration[5.1]
  def change
    add_reference :areas, :propriedade, index: true, foreign_key: true
  end
end
