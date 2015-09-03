class AnswersMailer < ApplicationMailer

  def notify_question_owner(answer)
    @answer        = answer
    @question      = answer.question
    @question_user = @question.user
    mail(to: @question_user.email, subject: "You've got an answer!")
  end
end
