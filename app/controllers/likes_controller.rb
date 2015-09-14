class LikesController < QuestionNestingsController

  def create
    l = Like.new(question: @question, user: current_user)
    respond_to do |format|
      if l.save
        format.html { redirect_to @question, notice: "Liked!" }
        format.js   { render }
      else
        format.html { redirect_to @question, alert: "Can't Like!" }
        format.js   { render }
      end
    end
  end

  def destroy
    like     = Like.find params[:id]

    respond_to do |format|
      if can? :destroy, like
        like.destroy
        format.html { redirect_to @question, notice: "Un-Liked" }
        format.js   { render }
      else
        format.html { redirect_to root_path, alert: "access denied" }
        format.js   { render }
      end
    end
  end
end
