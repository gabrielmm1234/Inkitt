class QuizzesController < ApplicationController
  TOTAL_ASNWERS = 5

  before_action :handle_completed_request, except: %i[results answers_distribution]
  before_action :set_quiz, only: %i[update]

  def quiz
    if cookies[:question_number]
      @quiz = Quiz.find(cookies[:quiz_id])
    else
      @quiz = Quiz.new
      cookies.permanent[:question_number] = 1
    end
    render "question_#{cookies[:question_number]}"
  end

  def results
    redirect_to root_path unless cookies[:completed]
  end

  def answers_distribution
    render json: Quiz.retrieve_answers_distribution
  end

  def create
    @quiz = Quiz.new(quiz_params)
    if create_allowed?
      @quiz.save
      cookies.permanent[:quiz_id] = @quiz.id
      cookies[:question_number] = 2
      redirect_to quiz_path
    else
      redirect_to_correct_path
    end
  end

  def update
    if update_allowed?
      @quiz.update(quiz_params)
      cookies[:question_number] = cookies[:question_number].to_i + 1
      deduct_redirect_path
    else
      redirect_to_correct_path
    end
  end

  private

  # Method used to allow put request based on the user current question number
  def update_allowed?
    params[:quiz].keys.to_s == "[\"answer#{cookies[:question_number]}\"]"
  end

  # Method used to allow post request based on the user current question number
  def create_allowed?
    params[:quiz].keys.to_s == "[\"answer#{cookies[:question_number]}\"]"
  end

  # Method used to redirect to the correct question if the user tries to go back or forward
  def redirect_to_correct_path
    redirect_to quiz_path,
                notice: "You cannot go back and change your answer, therefore your previous answer was not accepted!"
  end

  # Method used to check if the user has already finished the quiz, and redirect
  # to results if the quiz is completed
  def handle_completed_request
    redirect_to results_path if cookies[:completed]
  end

  # Update use this method to pick the correct path to redirect
  def deduct_redirect_path
    if cookies[:question_number] == TOTAL_ASNWERS + 1
      finish_quiz
    else
      redirect_to quiz_path
    end
  end

  # Complete the quiz and redirects to the results page.
  def finish_quiz
    quiz = Quiz.find(cookies[:quiz_id])
    quiz.update(completed: true)
    cookies.permanent[:completed] = true
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
