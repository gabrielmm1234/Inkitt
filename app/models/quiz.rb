class Quiz < ApplicationRecord
  ANSWER_OPTIONS = {answer1: %w[Yes No],
                    answer2: %w[1\ month 6\ months 1\ year],
                    answer3: %w[Java Ruby Javascript C],
                    answer4: %w[less\ than\ 1\ year 1-2\ years 2-3\ years 3-4\ years],
                    answer5: %w[No! Yes Maybe\ :(]}.freeze

  def self.retrieve_answers_distribution
    ANSWER_OPTIONS.keys.map {|key| build_answer_distribution(key) }
  end

  def self.build_answer_distribution(answer_number)
    quiz = Quiz.where(completed: true).group(answer_number).count
    quiz.map {|value, quantity| {name: ANSWER_OPTIONS[answer_number][value - 1], y: quantity} }
  end
end
