class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_filter :set_locale

  def set_locale
    # if params[:locale] is nil then I18n.default_locale will be used
    I18n.locale = params[:locale]
  end

  def default_url_options(options={})
    { :locale => I18n.locale }
  end
end

