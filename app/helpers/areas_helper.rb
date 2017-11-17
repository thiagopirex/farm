module AreasHelper
  def getImgBase64(a)
    if !a.foto_conteudo.nil?
      ('<img style="width: 350px; height: 250px;" src="data:' + a.foto_tipo + ';base64,%s">' % Base64.encode64(a.foto_conteudo)).html_safe
    end
  end
end
