class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  has_many :comments, dependent: :destroy

  validates :body, presence: {message: "Answer is required"},
                   # answer body is unique per question
                   uniqueness: {scope: :question_id}
  scope :latest_first, lambda { order("created_at DESC") }
  # def self.latest_first
  #   order("created_at DESC")
  # end

  def user_name
    if user
      user.full_name
    else
      "Anonymous"
    end
  end
end
