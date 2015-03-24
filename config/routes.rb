Blocipedia::Application.routes.draw do

  resources :charges, only: [:new, :create]

  devise_for :users

  resources :wikis do
    resources :collaborators, only: [:create, :destroy]
  end

  get 'about' => 'welcome#about'

  root to: 'welcome#index'

end