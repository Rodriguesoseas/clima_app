require "net/http"
require "json"
require "uri"

class WeatherService
  def self.fetch(cidade)
    cidade = cidade.to_s.strip
    return { erro: "Digite uma cidade válida", status: 400 } if cidade.empty?

    cidade_encoded = URI.encode_www_form_component(cidade)
    geo_url = URI("https://nominatim.openstreetmap.org/search?q=#{cidade_encoded},Brazil&format=json&limit=1")

    http = Net::HTTP.new(geo_url.host, geo_url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(geo_url)
    request["User-Agent"] = "ClimaApp/1.0 (contato@exemplo.com)"
    response = http.request(request)

    return { erro: "Erro ao buscar localização", status: 500 } unless response.code == "200"

    geo_data = JSON.parse(response.body)
    return { erro: "Cidade não encontrada", status: 404 } if geo_data.blank?

    lat = geo_data[0]["lat"].to_f
    lon = geo_data[0]["lon"].to_f

    weather_url = URI("https://api.open-meteo.com/v1/forecast?latitude=#{lat}&longitude=#{lon}&current_weather=true")
    weather_response = Net::HTTP.get(weather_url)
    weather_data = JSON.parse(weather_response)

    return { erro: "Erro ao buscar clima", status: 500 } if weather_data["current_weather"].nil?

    {
      cidade: geo_data[0]["display_name"],
      temperatura: weather_data["current_weather"]["temperature"],
      vento: weather_data["current_weather"]["windspeed"],
      weathercode: weather_data["current_weather"]["weathercode"],
      lat: lat,
      lon: lon,
      status: 200
    }
  rescue StandardError
    { erro: "Falha inesperada ao consultar APIs externas", status: 500 }
  end
end
