RSpec.describe "Home", type: :request do
  context "ログインしていないとき" do
    specify "ログイン画面にリダイレクトする" do
      get root_path
      expect(response).to redirect_to(new_session_path)
    end
  end

  context "ログイン済みのとき" do
    before do
      post session_path, params: { user: { name: "Yuichi Takeuchi", email: "yuichi.takeuchi@takeyuweb.co.jp" } }
    end

    specify "トップページを表示する" do
      get root_path
      expect(response).to have_http_status(:success)
    end
  end
end
