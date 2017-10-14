require 'rails_helper'

RSpec.describe QuizzesController, type: :controller do
  let(:quiz) { FactoryGirl.create :quiz }

  describe "GET #quiz" do
    it "returns http success" do
      get :quiz
      expect(response).to have_http_status(:success)
    end

    it "sets the question_number cookie to one in the first question" do
      get :quiz
      expect(response.cookies['question_number']).to eq('1')
    end

    it "renders the correct page according to user question number" do
      request.cookies['question_number'] = 2
      request.cookies['quiz_id'] = quiz.id
      get :quiz
      expect(response).to render_template("question_2")
    end
  end

  describe "GET #results" do
    it "returns http success" do
      request.cookies[:completed] = true
      get :results
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #answers_distribution" do
    it "is a json response" do
      get :answers_distribution
      expect(response.header['Content-Type']).to eq 'application/json; charset=utf-8'
    end

    it "has the answers distribution for each question" do
      FactoryGirl.create(:quiz)
      expected_answers_distribution = [[{"name"=>"Yes", "y"=>1}],
                                      [{"name"=>"6 months", "y"=>1}],
                                      [{"name"=>"Java", "y"=>1}],
                                      [{"name"=>"1-2 years", "y"=>1}],
                                      [{"name"=>"No!", "y"=>1}]]
      get :answers_distribution
      answers_distribution = JSON.parse response.body
      expect(answers_distribution).to eq(expected_answers_distribution)
    end
  end

  describe "handle_completed_request" do
    it "allows the request if the quiz is not completed yet" do
      request.cookies[:quiz_id] = quiz.id
      request.cookies['question_number'] = 2
      get :quiz
      expect(response).to have_http_status(:success)
    end

    it "blocks the request if the quiz is completed" do
      request.cookies[:quiz_id] = quiz.id
      request.cookies[:completed] = true
      get :quiz
      response.should redirect_to results_path
    end
  end

  describe "POST #create" do
    it "saves the quiz with the first answer" do
      request.cookies['question_number'] = 1
      post :create, params: { quiz: { answer1: 1 } }
      expect(response.cookies['question_number']).to eq('2')
      expect(Quiz.last.answer1).to eq(1)
    end

    it "blocks creation if the user tries to go back using the go back button from the browser" do
      request.cookies[:quiz_id] = quiz.id
      request.cookies['question_number'] = 2
      post :create, params: { quiz: { answer1: 2 } }
      expect(Quiz.last.answer1).to eq(1)
      response.should redirect_to quiz_path
    end

    it "allows creation if the user tries to answer it's current question" do
      request.cookies[:quiz_id] = quiz.id
      request.cookies['question_number'] = 1
      post :create, params: { quiz: { answer1: 2 } }
      expect(Quiz.last.answer1).to eq(2)
    end
  end

  describe "PATCH #update" do
    it "updates the user quiz with the next answer" do
      request.cookies[:quiz_id] = quiz.id
      request.cookies['question_number'] = 2
      put :update, params: { id: quiz.id, quiz: { answer2: 2 } }
      expect(response.cookies['question_number']).to eq('3')
      expect(Quiz.last.answer2).to eq(2)
    end

    it "blocks updates if the user tries to go back using the go back button from the browser" do
      request.cookies[:quiz_id] = quiz.id
      request.cookies['question_number'] = 4
      put :update, params: { id: quiz.id, quiz: { answer3: 2 } }
      expect(Quiz.last.answer3).to eq(1)
      response.should redirect_to quiz_path
    end

    it "allows updates if the user tries to answer it's current question" do
      request.cookies[:quiz_id] = quiz.id
      request.cookies['question_number'] = 3
      put :update, params: { id: quiz.id, quiz: { answer3: 2 } }
      expect(Quiz.last.answer3).to eq(2)
    end

    it "deduct the next route based on the question_number cookie" do
      request.cookies[:quiz_id] = quiz.id
      request.cookies['question_number'] = 3
      put :update, params: { id: quiz.id, quiz: { answer3: 2 } }
      response.should redirect_to quiz_path
    end

    it "redirects to results screen if the user completes the quiz" do
      request.cookies[:quiz_id] = quiz.id
      request.cookies['question_number'] = 5
      put :update, params: { id: quiz.id, quiz: { answer5: 2 } }
      response.should redirect_to results_path
      expect(response.cookies['completed']).to eq("true")
    end
  end
end
