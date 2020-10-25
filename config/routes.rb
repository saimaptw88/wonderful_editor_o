Rails.application.routes.draw do
  root to: "home#index"

  # reload 対策
  get "sign_up", to: "home#index"
  get "sign_in", to: "home#index"
  get "articles/new", to: "home#index"
  get "articles/:id", to: "home#index"

  namespace :api do
    namespace :v1 do
      # current_articles
      namespace :current do
        resources :articles, only: [:index]
      end

      # draftのルーティング( articlesのルーティングの前に設定しないとエラーする )
      namespace :articles do
        resources :draft, only: [:index, :show]
      end

      mount_devise_token_auth_for "User", at: "auth", controllers: {
        registrations: "api/v1/auth/registrations",
      }

      # articlesのルーティング
      resources :articles
    end
  end
end
