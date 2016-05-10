Rails.application.routes.draw do
  get 'shorten', to: 'url_shorteners#shorten'
end
