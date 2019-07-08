Stripe.api_key = ENV["STRIPE_SECRET_KEY"] || Rails.application.credentials.stripe[:secret_key]
