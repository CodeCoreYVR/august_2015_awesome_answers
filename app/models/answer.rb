class Answer < ActiveRecord::Base
  belongs_to :question
  has_many :comments, dependent: :destroy

  validates :body, presence: {message: "Answer is required"},
                   # answer body is unique per question
                   uniqueness: {scope: :question_id}
end
