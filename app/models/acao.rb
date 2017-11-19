class Acao < ActiveRecord::Base
  belongs_to :area
  
  validates_presence_of :dt_acao, :message => "A data é obrigatória!"
  validates_presence_of :nm_acao, :message => "O nome da ação é obrigatório!"
 
end

