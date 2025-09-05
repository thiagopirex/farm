class AddPastagemAtualToAreas < ActiveRecord::Migration[8.0]
  def change
    add_column :areas, :pastagem_atual, :string
  end
end
