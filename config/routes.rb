Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resource :user do
        post 'login'
        get 'profile'
        delete 'sign_out'
      end
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
