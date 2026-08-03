class WeatherController < ApplicationController
  before_action :require_login, only: [:buscar]

  def index; end

  def buscar
    result = WeatherService.fetch(params[:cidade])
    status = result.delete(:status) || 200

    respond_to do |format|
      format.json { render json: result, status: status }

      format.html do
        if result.key?(:erro)
          render partial: "components/error_state", locals: { mensagem: result[:erro] }, status: status, layout: false
        else
          render partial: "components/weather_dashboard", locals: { clima: result }, layout: false
        end
      end
    end
  end
end
