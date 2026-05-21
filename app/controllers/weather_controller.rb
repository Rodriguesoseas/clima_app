class WeatherController < ApplicationController
  before_action :require_login, only: [:buscar]

  def index; end

  def buscar
    result = WeatherService.fetch(params[:cidade])
    status = result.delete(:status) || 200
    render json: result, status: status
  end
end