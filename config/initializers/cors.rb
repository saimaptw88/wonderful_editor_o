# config/initializers/cors.rb

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "http://localhost:8080"
    resource "*",
             headers: :any,
             methods: [:get, :post, :put, :patch, :delete, :options, :head],

             # cookieを利用する場合
             credentials: true
  end
end
