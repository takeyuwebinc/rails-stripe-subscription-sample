RSpec.describe "Login", type: :request do
  specify do
    get new_session_path
    expect(response).to have_http_status(:success)

    post session_path, params: { user: { name: "Yuichi Takeuchi", email: "yuichi.takeuchi@takeyuweb.co.jp" } }
    expect(response).to have_http_status(:redirect)
    expect(response).to redirect_to(root_path)

    follow_redirect!

    expect(response).to have_http_status(:success)
    expect(response.body).to include "Yuichi Takeuchi"
  end
end
