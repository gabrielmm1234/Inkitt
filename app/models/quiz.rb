class Quiz < ApplicationRecord
  def self.retrieve_answers_distribution
    answers_distribution = []
    answers_distribution << build_answer_with_two_options("Yes", "No", "answer1")
    answers_distribution << build_answer_with_three_options("1 month", "6 months", "1 year", "answer2")
    answers_distribution << build_answer_with_four_options("Java", "Ruby", "Javascript", "C", "answer3")
    answers_distribution << build_answer_with_four_options("less than 1 year", "1-2 years", "2-3 years", "3-4 years",
                                                           "answer4")
    answers_distribution << build_answer_with_three_options("No!", "Yes", "Maybe :(", "answer5")
  end

  def self.build_answer_with_two_options(option1, option2, answer_number)
    filtered_quiz = []
    quiz = Quiz.where(completed: true).group(answer_number).count
    quiz.each do |value, quantity|
      answer = {}
      answer[:name] = value == 1 ? option1 : option2
      answer[:y] = quantity
      filtered_quiz << answer
    end
    filtered_quiz
  end

  def self.build_answer_with_three_options(option1, option2, option3, answer_number)
    filtered_quiz = []
    quiz = Quiz.where(completed: true).group(answer_number).count
    quiz.each do |value, quantity|
      answer = {}
      answer[:name] = if value.eql? 1
                        option1
                      elsif value.eql? 2
                        option2
                      else
                        option3
                      end
      answer[:y] = quantity
      filtered_quiz << answer
    end
    filtered_quiz
  end

  def self.build_answer_with_four_options(option1, option2, option3, option4, answer_number)
    filtered_quiz = []
    quiz = Quiz.where(completed: true).group(answer_number).count
    quiz.each do |value, quantity|
      answer = {}
      answer[:name] = if value.eql? 1
                        option1
                      elsif value.eql? 2
                        option2
                      elsif value.eql? 3
                        option3
                      else
                        option4
                      end
      answer[:y] = quantity
      filtered_quiz << answer
    end
    filtered_quiz
  end
end
