class QuizzesController < ApplicationController
  before_action :set_quiz, only: %i[question_2 question_3 question_4
                                    question_5 update]
  before_action :handle_completed_request, except: %i[results answers_distribution]
  before_action :allow_request, only: %i[question_1 question_2 question_3 question_4
                                         question_5]

  def question_1
    @quiz = Quiz.new
    cookies.permanent[:question_number] = 1
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
    redirect_to root_path unless cookies[:completed]
  end

  def answers_distribution
    @answers_distribution = Quiz.retrieve_answers_distribution
    render json: @answers_distribution
  end

  def create
    @quiz = Quiz.new(quiz_params)
    if @quiz.save
      cookies.permanent[:quiz_id] = @quiz.id
      cookies[:question_number] = 2
      redirect_to question_2_path
    else
      redirect_to root_path, notice: "Something went wrong :("
    end
  end

  def update
    if allow_update(@quiz)
      cookies[:question_number] = cookies[:question_number].to_i + 1
      deduct_redirect_path
    else
      redirect_to "/quizzes/question_#{cookies[:question_number]}",
                  notice: "You cannot go back and change your answer, therefore your previous answer was not accepted!"
    end
  end

  private

  def allow_update(quiz)
    (params[:quiz].keys.to_s.eql? "[\"answer#{cookies[:question_number]}\"]") && quiz.update(quiz_params)
  end

  def allow_request
    if cookies[:question_number]
      unless action_name.eql? "question_#{cookies[:question_number]}"
        redirect_to "/quizzes/question_#{cookies[:question_number]}"
      end
    end
  end

  def handle_completed_request
    redirect_to results_path if cookies[:completed]
  end

  def deduct_redirect_path
    if cookies[:question_number].eql? 6
      finish_quiz
    else
      redirect_to "/quizzes/question_#{cookies[:question_number]}"
    end
  end

  def finish_quiz
    quiz = Quiz.find(cookies[:quiz_id])
    quiz.update(completed: true)
    cookies.permanent[:completed] = true
    cookies.delete :question_number
    cookies.delete :quiz_id
    redirect_to results_path
  end

  def set_quiz
    @quiz = Quiz.find(cookies[:quiz_id])
  end

  def quiz_params
    params.require(:quiz).permit(:answer1, :answer2, :answer3, :answer4,
                                 :answer5)
  end
end
