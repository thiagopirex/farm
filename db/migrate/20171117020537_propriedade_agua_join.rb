class PropriedadeAguaJoin < ActiveRecord::Migration[5.1]
  def change
      add_column :aguas, :propriedade_id, :integer
      add_index  :aguas, :propriedade_id
  end
end
