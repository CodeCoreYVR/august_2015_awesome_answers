class AddIndicesToQuestions < ActiveRecord::Migration
  def change
    add_index :questions, :title
    add_index :questions, :body
  end
end
