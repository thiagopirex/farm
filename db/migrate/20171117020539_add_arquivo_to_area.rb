class AddArquivoToArea < ActiveRecord::Migration[5.1]
  def change
    add_column :areas, :foto_conteudo, :binary
    add_column :areas, :foto_tipo, :string
  end
end
