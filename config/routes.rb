HireCrm::Application.routes.draw do

  resources :records
  resources :search

  #################
  # Custom Routes #
  #################

  root :to => 'sessions#new'

  get 'login',     to: 'sessions#new',     as: 'login'
  post 'login',    to: 'sessions#login'
  get 'signup',    to: 'sessions#signup',  as: 'signup'
  post 'signup',   to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy', as: 'logout'

  get 'dashboard', to: 'users#dashboard'

  post 'jobs/import_job' => 'jobs#import_job'
  get 'jobs/import_result' => 'jobs#import_result'

  ###############################################
  # Routes for Refactored State Maching Buttons #
  ###############################################

  get  'jobs/:id/state_action' => 'states#state_action', as: 'change_state'
  post 'jobs/:id/state_action' => 'states#state_action', as: 'change_state'

  get  'interviews/:interview_id/state_action' => 'states#state_action', as: 'change_state'
  post 'interviews/:interview_id/state_action' => 'states#state_action', as: 'change_state'

  post 'jobs/:id' => 'states#admin_like'

  ##################
  # RESTful Routes #
  ##################

  resources :companies do 
    resources :jobs,
      :controller => 'companies/jobs',
      :only => [:new]
  end
  
  resources :jobs do 
    resources :interviews,
      :controller => 'jobs/interviews',
      :only => [:new]
  end

  resources :users do 
    resources :interviews,
      :controller => 'users/interviews',
      :only => [:new]
  end

  resources :interviews do
    resource :comment,
      :controller => 'interviews/comments',
      :only => [:new, :create]
  end
  
end