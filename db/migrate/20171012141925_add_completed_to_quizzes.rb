class AddCompletedToQuizzes < ActiveRecord::Migration[5.0]
  def change
    add_column :quizzes, :completed, :boolean, default: false
  end
end
