class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    q          = Question.find params[:question_id]
    # l          = Like.new
    # l.user     = current_user
    # l.question = q
    l          = Like.new(question: q, user: current_user)
    if l.save
      # redirect_to question_path(q), notice: "Liked!"
      redirect_to q, notice: "Liked!"
    else
      # redirect_to question_path(q), alert: "Can't Like!"
      redirect_to q, alert: "Can't Like!"
    end
  end

  def destroy
    like     = Like.find params[:id]
    if can? :destroy, like
      question = Question.find params[:question_id]
      like.destroy
      redirect_to question_path(question), notice: "Un-Liked"
    else
      redirect_to root_path, alert: "access denied"
    end
  end
end
