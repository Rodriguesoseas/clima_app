require 'net/http'
require 'json'
require 'uri'

class WeatherController < ApplicationController
  def index
  end

  def buscar
    cidade = params[:cidade].to_s.strip

    if cidade.empty?
      render json: { erro: "Digite uma cidade válida" }, status: 400
      return
    end

    cidade_encoded = URI.encode_www_form_component(cidade)

    geo_url = URI("https://nominatim.openstreetmap.org/search?q=#{cidade_encoded},Brazil&format=json&limit=1")

    http = Net::HTTP.new(geo_url.host, geo_url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(geo_url)
    request["User-Agent"] = "meu-app-clima (teste@teste.com)"

    response = http.request(request)

    if response.code != "200"
      render json: { erro: "Erro ao buscar localização" }, status: 500
      return
    end

    geo_data = JSON.parse(response.body)

    if geo_data.nil? || geo_data.empty?
      render json: { erro: "Cidade não encontrada" }, status: 404
      return
    end

    lat = geo_data[0]["lat"]
    lon = geo_data[0]["lon"]

    weather_url = URI("https://api.open-meteo.com/v1/forecast?latitude=#{lat}&longitude=#{lon}&current_weather=true")

    weather_response = Net::HTTP.get(weather_url)
    weather_data = JSON.parse(weather_response)

    if weather_data["current_weather"].nil?
      render json: { erro: "Erro ao buscar clima" }, status: 500
      return
    end

    render json: {
      cidade: geo_data[0]["display_name"],
      temperatura: weather_data["current_weather"]["temperature"],
      vento: weather_data["current_weather"]["windspeed"],
      lat: lat,
      lon: lon
    }
  end
end