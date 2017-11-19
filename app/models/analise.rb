class Analise < ActiveRecord::Base
  belongs_to :area
  validate :file_size_under_five_mb

  def initialize(params = {})
    @file = params.delete(:file)
    super
    if @file
      self.arquivo_nome = sanitize_filename(@file.original_filename)
      self.arquivo_tipo = @file.content_type
      self.arquivo_conteudo = @file.read
    end
  end

  private

    def sanitize_filename(filename)
      # Get only the filename, not the whole path (for IE)
      # Thanks to this article I just found for the tip: http://mattberther.com/2007/10/19/uploading-files-to-a-database-using-rails
      return File.basename(filename)
    end

    NUM_BYTES_IN_MEGABYTE = 5242880
    def file_size_under_five_mb
      if !@file.nil? && (@file.size.to_f / NUM_BYTES_IN_MEGABYTE) > 1
        errors.add(:file, 'O arquivo não pode ser maior que 5 megabyte.')
      end
    end

end

