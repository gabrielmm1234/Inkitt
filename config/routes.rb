Rails.application.routes.draw do
  get 'quizzes/quiz', as: 'quiz'

  get 'quizzes/results', as: 'results'

  get 'quizzes/answers_distribution', to: 'quizzes#answers_distribution', as: 'quizzes_answers_distribution'

  root 'home#index'

  resources :quizzes
end
