Rails.application.routes.draw do
  namespace :api do
    mount Facebook::Messenger::Server, at: 'bot'
  end
end
