require 'rails_helper'

RSpec.describe Quiz, type: :model do
  let!(:quiz) { FactoryGirl.create :quiz }

  describe 'retrieve_answers_distribution' do
    it "creates an array with the answers distribution" do
      expected_answers_distribution = [[{:name=>"Yes", :y=>1}],
                                      [{:name=>"6 months", :y=>1}],
                                      [{:name=>"Java", :y=>1}],
                                      [{:name=>"1-2 years", :y=>1}],
                                      [{:name=>"No!", :y=>1}]]
      answers_distribution = Quiz.retrieve_answers_distribution
      expect(answers_distribution).to eq(expected_answers_distribution)
    end

    it "ignores quizzes not completed" do
      FactoryGirl.create(:quiz, answer5: nil, completed: false)
      expected_answers_distribution = [[{:name=>"Yes", :y=>1}],
                                      [{:name=>"6 months", :y=>1}],
                                      [{:name=>"Java", :y=>1}],
                                      [{:name=>"1-2 years", :y=>1}],
                                      [{:name=>"No!", :y=>1}]]
      answers_distribution = Quiz.retrieve_answers_distribution
      expect(answers_distribution).to eq(expected_answers_distribution)
    end
  end

  describe 'build_answer_with_two_options' do
    it "creates the answers distribution for question with two answer options" do
      expected_answer_distribution = [{:name=>"Yes", :y=>1}]
      answer_distribution = Quiz.build_answer_with_two_options("Yes", "No", "answer1")
      expect(answer_distribution).to eq(expected_answer_distribution)
    end
  end

  describe 'build_answer_with_three_options' do
    it "creates the answers distribution for questions with three answer options" do
      expected_answer_distribution = [{:name=>"6 months", :y=>1}]
      answer_distribution = Quiz.build_answer_with_three_options("1 month", "6 months", "1 year", "answer2")
      expect(answer_distribution).to eq(expected_answer_distribution)
    end
  end

  describe 'build_answer_with_four_options' do
    it "creates the answers distribution for questions with four answer options" do
      expected_answer_distribution = [{:name=>"Java", :y=>1}]
      answer_distribution = Quiz.build_answer_with_four_options("Java", "Ruby", "Javascript", "C", "answer3")
      expect(answer_distribution).to eq(expected_answer_distribution)
    end
  end
end
