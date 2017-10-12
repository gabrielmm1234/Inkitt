class QuizzesController < ApplicationController
  before_action :set_quiz, only: %i[question_2 question_3 question_4
                                    question_5 update]
  before_action :allow_request, except: %i[results]

  def question_1
    @quiz = Quiz.new
  end

  def question_2
  end

  def question_3
  end

  def question_4
  end

  def question_5
  end

  def results
  end

  def create
    @quiz = Quiz.new(quiz_params)
    if @quiz.save
      redirect_to question_2_path(@quiz)
    else
      redirect_to root_path, notice: 'Something went wrong :('
    end
  end

  def update
    if @quiz.update(quiz_params)
      deduct_redirect_path(@quiz, params)
    else
      redirect_to root_path, notice: 'Something went wrong :('
    end
  end

  private

  def allow_request
    redirect_to results_path if cookies[:completed]
  end

  def deduct_redirect_path(quiz, params)
    if params[:quiz][:answer2]
      redirect_to question_3_path(quiz)
    elsif params[:quiz][:answer3]
      redirect_to question_4_path(quiz)
    elsif params[:quiz][:answer4]
      redirect_to question_5_path(quiz)
    else
      quiz.update(completed: true)
      cookies.permanent[:completed] = true
      redirect_to results_path
    end
  end

  def set_quiz
    @quiz = Quiz.find(params[:id])
  end

  def quiz_params
    params.require(:quiz).permit(:answer1, :answer2, :answer3, :answer4,
                                 :answer5)
  end
end
