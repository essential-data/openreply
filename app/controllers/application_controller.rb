class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action  :set_p3p
  before_action :set_locale
  layout :layout_by_resource
  rescue_from Otrs::ServiceError, with: :render_500


  def render_404
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found }
      format.any { head :not_found }
    end
  end

  def render_500
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/500", :layout => false, :status => :not_found }
      format.any { head :no_otrs_connection }
    end
  end

  private

  def set_p3p
    response.headers["P3P"]='CP="This is not a P3P policy! See http://mydomain.com/privacy-policy for more info."'
  end

  def layout_by_resource
    if devise_controller? && resource_name == :user && action_name == 'new'
      "devise"
    else
      "application"
    end
  end

  def set_locale
    SimplesIdeias::I18n.export!
    begin
      if params["lang"]
        # Symbol conversion from unsafe string (potential dos vulnerability)
        language = params["lang"].to_sym
        I18n.locale = language
        cookies["lang"] = language
      else
        I18n.locale = cookies["lang"] || http_accept_language.compatible_language_from(I18n.available_locales)
      end

    rescue I18n::InvalidLocale => e
      I18n.locale = I18n.default_locale
    end
  end

end
