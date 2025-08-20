Rails.application.routes.draw do
  root "home#index"
  devise_for :users

  # みんなの投稿一覧（非ネスト）
  resources :posts, only: [:index]

  # 既存：ぬい配下の投稿（詳細/作成など）
  resources :nuis do
    resources :posts do
      resource :like, only: [:create, :destroy]  # ← 単数資源！
      resources :comments, only: [:create, :destroy]
    end
  end
end
