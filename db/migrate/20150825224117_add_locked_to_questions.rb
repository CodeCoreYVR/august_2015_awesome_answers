class AddLockedToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :locked, :boolean, default: false
  end
end
