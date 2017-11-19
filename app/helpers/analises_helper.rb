module AnalisesHelper
  def formatDate (p)
    data = p[:data]
    data.strftime('%d / %m / %Y')
  end
end
