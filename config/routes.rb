Quilt::Application.routes.draw do
  
  root :to => 'quilt#index'
  get 'dashboard/base'
  get 'dashboard/navigation'
  get 'dashboard/grid'
  get 'dashboard/buttons'
  get 'dashboard/messages'
  get 'dashboard/tables'
  get 'dashboard/forms'
  get 'dashboard/wizard'
  get 'dashboard/providers'
  get 'dashboard/icons'
  get 'widgets/signin'
  get 'widgets/editProfile'
  get 'widgets/components'
  get 'portals/zendesk'
  
  resources :dashboard   
  resources :widgets
  resources :portals
  resources :quilt
  resources :providers
  resources :icons
 end
