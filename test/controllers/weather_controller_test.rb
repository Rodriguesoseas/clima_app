require "test_helper"

class WeatherControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      email: "teste@example.com",
      password: "senha123",
      password_confirmation: "senha123"
    )
  end

  test "index is public" do
    get root_url
    assert_response :success
  end

  test "buscar requires login" do
    get buscar_clima_url, params: { cidade: "Curitiba" }
    assert_response :unauthorized
  end

  test "buscar returns json when logged in" do
    post login_url, params: { email: @user.email, password: "senha123" }
    assert_redirected_to root_url

    get buscar_clima_url, params: { cidade: "Curitiba" }
    assert_includes [200, 404, 500], response.status
    assert_equal "application/json", response.media_type
  end
end
