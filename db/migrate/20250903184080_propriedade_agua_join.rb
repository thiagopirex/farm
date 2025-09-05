class PropriedadeAguaJoin < ActiveRecord::Migration[8.0]
  def change
      add_column :aguas, :propriedade_id, :integer
      add_index  :aguas, :propriedade_id
  end
end
