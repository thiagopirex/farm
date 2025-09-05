class AddPropriedadeToMalhaAguas < ActiveRecord::Migration[8.0]
  def change
    add_reference :malha_aguas, :propriedade, foreign_key: true
  end
end
