require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "GET cadastro retorna 200 com formulário" do
    get signup_path

    assert_response :success
    assert_select "form"
  end

  test "POST cadastro com dados válidos cria usuário, sessão e redireciona" do
    assert_difference "User.count", 1 do
      post signup_path, params: {
        user: {
          email: "novo@example.com",
          password: "senha123",
          password_confirmation: "senha123"
        }
      }
    end

    assert_redirected_to root_path
    user = User.find_by!(email: "novo@example.com")
    assert_equal user.id, session[:user_id]
  end

  test "POST cadastro com e-mail duplicado retorna 422" do
    User.create!(
      email: "existente@example.com",
      password: "senha123",
      password_confirmation: "senha123"
    )

    assert_no_difference "User.count" do
      post signup_path, params: {
        user: {
          email: "existente@example.com",
          password: "outra123",
          password_confirmation: "outra123"
        }
      }
    end

    assert_response :unprocessable_entity
  end

  test "GET cadastro logado redireciona para root" do
    user = User.create!(
      email: "logado@example.com",
      password: "senha123",
      password_confirmation: "senha123"
    )

    post login_path, params: { email: user.email, password: "senha123" }
    get signup_path

    assert_redirected_to root_path
  end
end
