Rails.application.routes.draw do
  get 'quizzes/question_1', as: 'question_1'

  get 'quizzes/question_2/:id', to: 'quizzes#question_2', as: 'question_2'

  get 'quizzes/question_3/:id', to: 'quizzes#question_3', as: 'question_3'

  get 'quizzes/question_4/:id', to: 'quizzes#question_4', as: 'question_4'

  get 'quizzes/question_5/:id', to: 'quizzes#question_5', as: 'question_5'

  get 'quizzes/results', as: 'results'

  root 'home#index'

  resources :quizzes
end
