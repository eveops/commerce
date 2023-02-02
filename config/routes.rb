require 'sidekiq/web'
require "sidekiq-scheduler/web"

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"

  get "up" => "rails/health#show"

  root to: "welcome#index"
end
