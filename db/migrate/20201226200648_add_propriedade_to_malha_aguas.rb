class AddPropriedadeToMalhaAguas < ActiveRecord::Migration[5.1]
  def change
    add_reference :malha_aguas, :propriedade, foreign_key: true
  end
end
