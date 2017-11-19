class CreateAcaos < ActiveRecord::Migration[5.1]
  def change
    create_table :acaos do |t|
      t.string  :nm_acao
      t.date    :dt_acao
      t.decimal :vl_acao
      t.string  :ds_observacao
      t.timestamps null: false
    end
  end
end

