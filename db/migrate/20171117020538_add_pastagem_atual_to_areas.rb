class AddPastagemAtualToAreas < ActiveRecord::Migration[5.1]
  def change
    add_column :areas, :pastagem_atual, :string
  end
end
