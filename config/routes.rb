Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :offers do
      resources :images, controller: 'offer_images' do
        collection do
          post :update_positions
        end
      end
    end
  end
end
