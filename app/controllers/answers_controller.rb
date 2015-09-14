class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @question        = Question.friendly.find params[:question_id]
    # @answer  = @question.answers.new(answer_params)
    @answer          = Answer.new answer_params
    @answer.question = @question
    @answer.user     = current_user
    # respond_to allows us to reposnd differently to different request types
    # for instance we can send or do different things whether the format
    # is HTML, JS, JSON, XML..etc
    respond_to do |format|
      if @answer.save
        AnswersMailer.delay(run_at: 5.minutes.from_now).notify_question_owner(@answer)
        format.html { redirect_to question_path(@question), notice: "Answer created!" }
        # calling render in Rails will looking for ACTION.FORMAT.TEMPLATE_LANGUAGE
        # if you specify a template name as a symbol to `render` it will redner
        # that template instead of the default one
        # so in this case it will be: create_success.js.erb
        format.js   { render :create_success }
      else
        # this will render show.html.erb within questions folder (in views)
        # we're choosing to use "render" in here because we want to display
        # the errors resulting from unsuccessful save of @answer. The errors
        # are attached to the @answer object and can be accessed in:
        # @answer.errors
        # using redirect makes a whole new request cycles so we lose the @answer
        # object
        format.html do
          flash[:alert] = "Answer wasn't created"
          render "/questions/show"
        end
        format.js   { render :create_failure }
      end
    end
  end
# comment
  def destroy
    @answer   = Answer.find params[:id]
    @question = Question.friendly.find params[:question_id]
    @answer.destroy
    respond_to do |format|
      format.html { redirect_to question_path(@question), notice: "Answer deleted." }
      format.js   { render }
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
