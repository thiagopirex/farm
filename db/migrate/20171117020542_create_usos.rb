class CreateUsos < ActiveRecord::Migration[5.1]
  def change
    create_table :usos do |t|
      t.date :dt_inicio
      t.date :dt_fim
      t.integer :qnt_animais
      t.string :idade_animais

      t.timestamps null: false
    end
  end
end

