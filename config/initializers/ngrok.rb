if Rails.env.development?
  class NgrokTunnelling
    def initialize(app)
      puts "Starting Ngrok"
      Ngrok::Tunnel.start(addr: 3000)
      puts "* Forwarding: #{Ngrok::Tunnel.ngrok_url} -> http://localhost:3000"
      puts "* Forwarding: #{Ngrok::Tunnel.ngrok_url_https} -> http://localhost:3000"
      Rails.application.config.hosts << URI(Ngrok::Tunnel.ngrok_url).host
      @app = app
    end

    def call(env)
      @app.call(env)
    end
  end

  Rails.application.configure do |config|
    config.middleware.insert_after ActionDispatch::Static, NgrokTunnelling
  end
end
