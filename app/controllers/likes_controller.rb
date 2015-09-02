class LikesController < QuestionNestingsController

  def create
    l = Like.new(question: @question, user: current_user)
    if l.save
      redirect_to @question, notice: "Liked!"
    else
      redirect_to @question, alert: "Can't Like!"
    end
  end

  def destroy
    like     = Like.find params[:id]
    if can? :destroy, like
      like.destroy
      redirect_to @question, notice: "Un-Liked"
    else
      redirect_to root_path, alert: "access denied"
    end
  end
end
