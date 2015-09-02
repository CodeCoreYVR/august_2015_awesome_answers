class Favourite < ActiveRecord::Base
  belongs_to :user
  belongs_to :question

  validates :question_id, uniqueness: {scope: :user_id}

end
