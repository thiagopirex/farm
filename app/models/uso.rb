class Uso < ActiveRecord::Base
  belongs_to :area
  
  validates_presence_of :dt_inicio, :message => "A data de início é obrigatória!"
  
  validate :validate_data
  
  def total_animais
    return self.qnt_macho_faixa_um.to_i + self.qnt_macho_faixa_dois.to_i + self.qnt_macho_faixa_tres.to_i + self.qnt_femea_faixa_um.to_i + self.qnt_femea_faixa_dois.to_i + self.qnt_femea_faixa_tres.to_i
  end
  
  private 
  def validate_data
    if !self.dt_fim.nil?
      if dt_inicio >= dt_fim
        self.errors.add(:dt_fim, "A data de término deve ser posterior à data de início!")  
      end
    end
  end
  
  
end

