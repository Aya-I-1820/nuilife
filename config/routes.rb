# config/routes.rb
Rails.application.routes.draw do
  get 'home/index'
  root "home#index"                       # トップ画面
  devise_for :users                       # ← 1回だけ

  # ぬい → 投稿 → コメント/いいね（ユーザー単位）
  resources :nuis do
    resources :posts do
      resources :comments, only: [:create, :destroy]
      resource  :like,     only: [:create, :destroy]  # 単数資源: /posts/:post_id/like
    end
  end

  # ヘルスチェック
  get "up" => "rails/health#show", as: :rails_health_check
end
