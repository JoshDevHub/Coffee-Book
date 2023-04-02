Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV.fetch("GITHUB_CLIENT_ID", nil), ENV.fetch("GITHUB_CLIENT_SECRET", nil)
end
