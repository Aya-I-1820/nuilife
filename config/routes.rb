# config/routes.rb
Rails.application.routes.draw do
  root "home#index"

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  # ユーザープロフィール
  resources :users, only: [:show]

  # みんなの投稿一覧（グローバル）
  resources :posts, only: [:index]

  # ぬい配下（フォロー・投稿・コメント・いいね）
  resources :nuis do
    member do
      get :followers              # /nuis/:id/followers
    end
    resource  :follow, only: [:create, :destroy]

    resources :posts do
      collection do
        get :drafts               # ★ 下書き一覧 /nuis/:nui_id/posts/drafts
      end
      resource  :like,    only: [:create, :destroy]   # 単数資源
      resources :comments, only: [:create, :destroy]
    end
  end

  # DM
  resources :conversations, only: [:index, :show, :create] do
    resources :messages, only: [:create]
  end
end
