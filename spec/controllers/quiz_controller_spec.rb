require 'rails_helper'

RSpec.describe QuizController, type: :controller do

  describe "GET #question_1" do
    it "returns http success" do
      get :question_1
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #question_2" do
    it "returns http success" do
      get :question_2
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #question_3" do
    it "returns http success" do
      get :question_3
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #question_4" do
    it "returns http success" do
      get :question_4
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #question_5" do
    it "returns http success" do
      get :question_5
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #results" do
    it "returns http success" do
      get :results
      expect(response).to have_http_status(:success)
    end
  end

end
