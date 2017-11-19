module UsosHelper
  def formatDate (p)
    data = p[:data]
    if !data.nil?
      data.strftime('%d/%m/%Y')
    end
  end
  
  def calculaDiasCorridos(p)
    dias = 0
    inicio = p[:inicio]
    fim = p[:fim]
    if fim.nil?
      #fim = hoje
      fim = Date.today
    end
    dias = fim.mjd - inicio.mjd
  end
end
