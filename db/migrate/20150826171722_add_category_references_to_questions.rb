class AddCategoryReferencesToQuestions < ActiveRecord::Migration
  def change
    add_reference :questions, :category, index: true, foreign_key: true
  end
end
