Rails.application.routes.draw do
  get 'users/show'
  root "home#index"
  devise_for :users, controllers: {
  registrations: 'users/registrations'
}


  # みんなの投稿一覧（非ネスト）
  resources :posts, only: [:index]

  resources :users, only: [:show]

  # 既存：ぬい配下の投稿（詳細/作成など）
  resources :nuis do
    member do
      get :followers   # ← /nuis/:id/followers
    end
    resource  :follow,   only: [:create, :destroy] 
    resources :posts do
      resource :like, only: [:create, :destroy]  # ← 単数資源！
      resources :comments, only: [:create, :destroy]
    end
  end
end
