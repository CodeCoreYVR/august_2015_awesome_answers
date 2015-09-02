class FavouritesController < QuestionNestingsController

  def create
    favourite = Favourite.new(question: @question, user: current_user)
    if favourite.save
      redirect_to @question, notice: "Favourited!"
    else
      redirect_to @question, alert: "Can't Favourited!"
    end
  end

  def destroy
    favourite = Favourite.find params[:id]
    if can? :destroy, favourite
      favourite.destroy
      redirect_to @question, notice: "Removed Favourite Status"
    else
      redirect_to root_path, alert: "access denied"
    end
  end

end
