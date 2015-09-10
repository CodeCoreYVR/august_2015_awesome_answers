class CommentsMailer < ApplicationMailer

  def notify_answer_owner(comment)
    @comment = comment
    @answer  = comment.answer
    @user    = @answer.user
    mail(to: @user.email, subject: "You've got a comment")
  end
end
