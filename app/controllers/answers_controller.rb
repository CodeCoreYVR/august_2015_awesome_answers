class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @question        = Question.find params[:question_id]
    # @answer  = @question.answers.new(answer_params)
    @answer          = Answer.new answer_params
    @answer.question = @question
    @answer.user     = current_user
    if @answer.save
      AnswersMailer.notify_question_owner(@answer).deliver_now
      redirect_to question_path(@question), notice: "Answer created!"
    else
      flash[:alert] = "Answer wasn't created"
      # this will render show.html.erb within questions folder (in views)
      # we're choosing to use "render" in here because we want to display
      # the errors resulting from unsuccessful save of @answer. The errors
      # are attached to the @answer object and can be accessed in:
      # @answer.errors
      # using redirect makes a whole new request cycles so we lose the @answer
      # object
      render "/questions/show"
    end
  end
# comment
  def destroy
    @answer   = Answer.find params[:id]
    @question = Question.find params[:question_id]
    @answer.destroy
    redirect_to question_path(@question), notice: "Answer deleted."
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
