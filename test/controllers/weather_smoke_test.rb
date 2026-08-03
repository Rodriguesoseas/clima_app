require "test_helper"
require "minitest/mock"

class SmokeWeatherTest < ActionDispatch::IntegrationTest
  PAYLOAD = {
    cidade: "São Paulo", cidade_completa: "São Paulo, SP, Brasil",
    temperatura: 24.3, sensacao: 22.1, umidade: 68, vento: 12.4,
    direcao_vento: 210, pressao: 1014.2, uv: 6.3, precipitacao: 0.2,
    is_day: true, weathercode: 2, atualizado_em: "2026-08-02T14:00",
    horaria: [{ hora: "15:00", temp: 23.0, precipitacao: 10, weathercode: 2 }],
    diaria: [{ data: "2026-08-03", max: 27.0, min: 18.0, weathercode: 0, uv_max: 7, precipitacao: 0.0, nascer_sol: "06:31", por_sol: "17:47" }]
  }.freeze

  test "home logada renderiza busca e área de resultado" do
    user = User.create!(
      email: "smoke@example.com",
      password: "senha123",
      password_confirmation: "senha123"
    )
    post login_path, params: { email: user.email, password: "senha123" }
    get root_path

    assert_response :success
    assert_select "#clima-form"
    assert_select "#cidade"
    assert_select "#resultado"
    assert_select "#skeleton-template"
    assert_select "button[data-cidade]", count: 8
  end

  test "buscar_clima responde fragmento HTML quando logado" do
    WeatherService.stub(:fetch, PAYLOAD.dup) do
      user = User.create!(
        email: "smoke2@example.com",
        password: "senha123",
        password_confirmation: "senha123"
      )
      post login_path, params: { email: user.email, password: "senha123" }
      get buscar_clima_path(cidade: "São Paulo"), headers: { "Accept" => "text/html" }

      assert_response :success
      assert_match(/data-weather="sol"/, response.body)
      assert_match(/Próximos 7 dias/, response.body)
      assert_match(/data-count-up="24.3"/, response.body)
    end
  end

  test "buscar_clima segue respondendo JSON" do
    WeatherService.stub(:fetch, PAYLOAD.dup) do
      user = User.create!(
        email: "smoke3@example.com",
        password: "senha123",
        password_confirmation: "senha123"
      )
      post login_path, params: { email: user.email, password: "senha123" }
      get buscar_clima_path(cidade: "São Paulo"), headers: { "Accept" => "application/json" }

      assert_response :success
      body = JSON.parse(response.body)
      assert_equal "São Paulo", body["cidade"]
      assert_equal 24.3, body["temperatura"]
    end
  end

  test "buscar_clima exige login" do
    get buscar_clima_path(cidade: "São Paulo"), headers: { "Accept" => "text/html" }
    assert_response :unauthorized
  end
end
