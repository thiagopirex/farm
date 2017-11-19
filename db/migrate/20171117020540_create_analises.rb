class CreateAnalises < ActiveRecord::Migration[5.1]
  def change
    create_table :analises do |t|
      t.date :data
      t.string :arquivo_nome
      t.binary :arquivo_conteudo
      t.string :arquivo_tipo
      t.timestamps null: false
    end
  end
end
