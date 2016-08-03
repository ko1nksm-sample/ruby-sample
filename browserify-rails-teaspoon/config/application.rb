require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BrowserifyRailsTeaspoon
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.browserify_rails.commandline_options = '-t babelify --extension=.es6 --plugins transform-es2015-modules-commonjs'
    config.browserify_rails.paths << -> (p) { p.start_with?(Rails.root.join("spec/javascripts").to_s) }
  end
end
