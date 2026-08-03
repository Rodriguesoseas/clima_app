require "net/http"
require "json"
require "uri"

class WeatherService
  CURRENT_FIELDS = %w[
    temperature_2m apparent_temperature relative_humidity_2m
    is_day precipitation weather_code wind_speed_10m
    wind_direction_10m pressure_msl uv_index
  ].join(",")

  HOURLY_FIELDS = "temperature_2m,precipitation_probability,weather_code"
  DAILY_FIELDS = "weather_code,temperature_2m_max,temperature_2m_min,sunrise,sunset,uv_index_max,precipitation_sum"

  def self.fetch(cidade)
    cidade = cidade.to_s.strip
    return { erro: "Digite uma cidade válida", status: 400 } if cidade.empty?

    geo = geocode(cidade)
    return geo if geo.key?(:erro)

    clima = consultar_clima(geo[:lat], geo[:lon])
    return clima if clima.key?(:erro)

    montar_resposta(geo[:display_name], clima)
  rescue StandardError
    { erro: "Falha inesperada ao consultar APIs externas", status: 500 }
  end

  def self.geocode(cidade)
    url = URI("https://nominatim.openstreetmap.org/search?q=#{URI.encode_www_form_component(cidade)},Brazil&format=json&limit=1")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["User-Agent"] = "ClimaApp/1.0 (contato@exemplo.com)"
    response = http.request(request)

    return { erro: "Erro ao buscar localização", status: 500 } unless response.code == "200"

    dados = JSON.parse(response.body)
    return { erro: "Cidade não encontrada", status: 404 } if dados.blank?

    { lat: dados[0]["lat"].to_f, lon: dados[0]["lon"].to_f, display_name: dados[0]["display_name"] }
  end

  def self.consultar_clima(lat, lon)
    url = URI(
      "https://api.open-meteo.com/v1/forecast?latitude=#{lat}&longitude=#{lon}" \
      "&current=#{CURRENT_FIELDS}&hourly=#{HOURLY_FIELDS}&daily=#{DAILY_FIELDS}" \
      "&timezone=auto&forecast_days=7"
    )
    dados = JSON.parse(Net::HTTP.get(url))

    return { erro: "Erro ao buscar clima", status: 500 } if dados["current"].nil?

    dados
  end

  def self.montar_resposta(display_name, dados)
    atual = dados["current"]
    horaria = dados["hourly"]
    diaria = dados["daily"]

    indice = (horaria["time"].index { |t| t >= atual["time"] } || 0)

    proximas = (indice...(indice + 12)).map do |i|
      t = horaria["time"][i]
      {
        hora: t&.split("T")&.last&.slice(0, 5),
        temp: horaria["temperature_2m"][i],
        precipitacao: horaria["precipitation_probability"][i],
        weathercode: horaria["weather_code"][i]
      }
    end.compact

    dias = (0...7).map do |i|
      t = diaria["time"][i]
      {
        data: t,
        max: diaria["temperature_2m_max"][i],
        min: diaria["temperature_2m_min"][i],
        weathercode: diaria["weather_code"][i],
        uv_max: diaria["uv_index_max"][i],
        precipitacao: diaria["precipitation_sum"][i],
        nascer_sol: diaria["sunrise"][i]&.split("T")&.last&.slice(0, 5),
        por_sol: diaria["sunset"][i]&.split("T")&.last&.slice(0, 5)
      }
    end

    {
      cidade: display_name.split(",").first.to_s.strip,
      cidade_completa: display_name,
      temperatura: atual["temperature_2m"],
      sensacao: atual["apparent_temperature"],
      umidade: atual["relative_humidity_2m"],
      vento: atual["wind_speed_10m"],
      direcao_vento: atual["wind_direction_10m"],
      pressao: atual["pressure_msl"],
      uv: atual["uv_index"],
      precipitacao: atual["precipitation"],
      is_day: atual["is_day"] == 1,
      weathercode: atual["weather_code"],
      atualizado_em: atual["time"],
      horaria: proximas,
      diaria: dias,
      status: 200
    }
  end
end
