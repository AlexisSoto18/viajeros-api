# config/routes.rb
Rails.application.routes.draw do
  namespace :api do
    # 📌 Autenticación (van dentro de api, pero FUERA de admin)
    post 'register', to: 'registrations#create'
    post 'login',    to: 'sessions#create'
    get  'validate', to: 'sessions#validate'

    # 📌 Pueblo Mágico + contenidos anidados
    resources :pueblo_magicos do
      resources :places, only: [:index, :create]
      resources :events, only: [:index, :create]
      resources :jobs,   only: [:index, :create]
    end

    # 📌 Rutas de detalle/edición para cada recurso
    resources :places, only: [:show, :update, :destroy]
    resources :events, only: [:show, :update, :destroy]
    resources :jobs,   only: [:show, :update, :destroy]

    # 📌 Reservaciones (aceptar/rechazar/cancelar)
    resources :reservations, only: [:index, :create, :show] do
      member do
        post :accept
        post :reject
        post :cancel
      end
    end

    # 📌 Admin approvals (DENTRO de api, en su propio namespace)
    namespace :admin do
      resources :places, only: [] do
        member { post :approve; post :unapprove }
      end
      resources :events, only: [] do
        member { post :approve; post :unapprove }
      end
      resources :jobs, only: [] do
        member { post :approve; post :unapprove }
      end
    end
  end
end
