class Uso < ActiveRecord::Base
  belongs_to :area
  
  validates_presence_of :dt_inicio, :message => "A data de início é obrigatória!"
  validates_presence_of :qnt_animais, :message => "A quantidade de animais é obrigatória!"
  validates_presence_of :idade_animais, :message => "A idade média é obrigatória!"
  
  validate :validate_data
  
  private 
  def validate_data
    if !self.dt_fim.nil?
      if dt_inicio >= dt_fim
        self.errors.add(:dt_fim, "A data de término deve ser posterior à data de início!")  
      end
    end
  end
end

