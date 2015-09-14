class FavouritesController < QuestionNestingsController

  def create
    favourite = Favourite.new(question: @question, user: current_user)
    respond_to do |format|
      if favourite.save
        format.html { redirect_to @question, notice: "Favourited!" }
        format.js   { render }
      else
        format.html { redirect_to @question, alert: "Can't Favourited!" }
        format.js   { render }
      end
    end
  end

  def destroy
    favourite = Favourite.find params[:id]
    respond_to do |format|
      if can? :destroy, favourite
        favourite.destroy
        format.html { redirect_to @question, notice: "Removed Favourite Status" }
        format.js   { render }
      else
        format.html { redirect_to root_path, alert: "access denied" }
        format.js   { render }
      end
    end
  end

end
