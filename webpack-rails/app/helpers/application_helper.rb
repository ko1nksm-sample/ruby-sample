module ApplicationHelper
  def webpack_asset_path(path)
    assets = JSON.parse(File.read(Rails.root + 'webpack-assets.json'))
    name, ext = path.match(/(.+)\.(.+)/).captures
    '/assets/' + assets[name][ext]
  end
end
