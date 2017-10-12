Rails.application.routes.draw do
  get 'quiz/question_1', as: 'question_1'

  get 'quiz/question_2', as: 'question_2'

  get 'quiz/question_3', as: 'question_3'

  get 'quiz/question_4', as: 'question_4'

  get 'quiz/question_5', as: 'question_5'

  get 'quiz/results', as: 'results'

  root 'home#index'
end
