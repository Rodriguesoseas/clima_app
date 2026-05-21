require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "GET login retorna 200" do
    get login_path

    assert_response :success
    assert_select "h1", "Entrar"
    assert_select "a[href=?]", signup_path, text: "Cadastrar"
  end
end
