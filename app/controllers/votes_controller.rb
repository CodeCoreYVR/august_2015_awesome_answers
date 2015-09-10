class VotesController < ApplicationController
  before_action :authenticate_user!, :find_question

  def create
    vote          = Vote.new vote_params
    vote.user     = current_user
    vote.question = @question
    if vote.save
      redirect_to question_path(@question), notice: "Voted!"
    else
      redirect_to question_path(@question), alert: "Can't Vote!"
    end
  end

  def update
    vote = Vote.find params[:id]
    if !(can? :update, vote)
      redirect_to root_path, alert: "access denied"
    elsif vote.update vote_params
      redirect_to @question, notice: "Vote updated"
    else
      redirect_to @question, alert: "Vote was not updated"
    end
  end

  def destroy
    vote = Vote.find params[:id]
    if can? :destroy, vote
      vote.destroy
      redirect_to @question, notice: "Vote removed!"
    else
      redirect_to root_path, alert: "access denied"
    end
  end

  private

  def vote_params
    params.require(:vote).permit(:up)
  end

  def find_question
    @question = Question.friendly.find params[:question_id]
  end

end
