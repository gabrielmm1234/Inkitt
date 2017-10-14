require 'rails_helper'

RSpec.describe QuizzesController, type: :controller do
  let(:quiz) { FactoryGirl.create :quiz }

  describe "GET #question_1" do
    it "returns http success" do
      get :question_1
      expect(response).to have_http_status(:success)
    end

    it "sets the question_number cookie to one" do
      get :question_1
      expect(response.cookies['question_number']).to eq('1')
    end
  end

  describe "GET #question_2" do
    it "returns http success" do
      request.cookies[:quiz_id] = quiz.id
      get :question_2
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #question_3" do
    it "returns http success" do
      request.cookies[:quiz_id] = quiz.id
      get :question_3, params: { id: quiz.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #question_4" do
    it "returns http success" do
      request.cookies[:quiz_id] = quiz.id
      get :question_4, params: { id: quiz.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #question_5" do
    it "returns http success" do
      request.cookies[:quiz_id] = quiz.id
      get :question_5, params: { id: quiz.id }
      expect(response).to have_http_status(:success)
    end
  end


  describe "GET #results" do
    it "returns http success" do
      request.cookies[:completed] = true
      get :results
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    it "saves the quiz with the first answer" do
      request.cookies['question_number'] = 1
      post :create, params: { quiz: { answer1: 1 } }
      expect(response.cookies['question_number']).to eq('2')
      expect(Quiz.last.answer1).to eq(1)
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
  end
  
end
