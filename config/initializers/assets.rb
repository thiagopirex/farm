# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
#Rails.application.config.assets.precompile += %w( bootstrap.min.js bootstrap.min.css )
Rails.application.config.assets.precompile += %w( bootstrap.css )
Rails.application.config.assets.precompile += %w( bootstrap-datepicker.css )
Rails.application.config.assets.precompile += %w( leaflet.css )
Rails.application.config.assets.precompile += %w( leaflet.draw.css )
Rails.application.config.assets.precompile += %w( leaflet-measure.css )
Rails.application.config.assets.precompile += %w( Leaflet.Coordinates-0.1.5.css )

Rails.application.config.assets.precompile += %w( bootstrap.js )
Rails.application.config.assets.precompile += %w( bootstrap-datepicker.js )
Rails.application.config.assets.precompile += %w( bootstrap-datepicker.pt-BR.js )
Rails.application.config.assets.precompile += %w( leaflet.js )
Rails.application.config.assets.precompile += %w( leaflet.draw.js )
Rails.application.config.assets.precompile += %w( leaflet-geodesy )
Rails.application.config.assets.precompile += %w( leaflet-measure )
Rails.application.config.assets.precompile += %w( Leaflet.Coordinates-0.1.5.min )
