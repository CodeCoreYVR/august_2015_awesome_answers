class QuestionsController < ApplicationController

  # the new action is the one that is used by convention in Rails to display
  # a form to create the record (in this case question record)
  def new
    # We instantiate an instance variable of the object we'd like to create in
    # order to use the `form_for` helper method in Rails to easily generate
    # a form that submits to the create action
    @question = Question.new # Question.new(title: "hello")
  end

  def create
    # params[:question] => {title: "Abc", body: "xyz"}
    # params.require ensures that the params hash has a key :question and
    # fetches all the attributes from that hash. the .permit only allows
    # the parameters given to be mass-assigned
    question_params = params.require(:question).permit([:title, :body])
    # question_params =>  {title: "Abc", body: "xyz"}
    @question = Question.new(question_params)
    if @question.save
      redirect_to question_path(@question)
    else
      render :new
    end
  end

  # GET /questions/:id (e.g. /questions/1)
  # this is used to show a page with question information
  def show
    @question = Question.find params[:id]
  end

  # GET /questions
  # this is used to show a page with listing of all the questions in our DB
  def index
    @questions = Question.all
  end

  # GET /questions/:id/edit (e.g. /questions/123/edit )
  # this is used to show a form to edit and submit to update a question in the database
  def edit
    @question = Question.find params[:id]
  end

  # PATCH /questions/:id (e.g. /questions/123)
  # this is used to handle the submission of the question form from the edit page
  # when user is updating the information on a question
  def update
    # this is using the strong parameters feature in Rails to only allow
    # the title and body to be updated in the database
    question_params = params.require(:question).permit(:title, :body)
    @question = Question.find params[:id]
    # if updating the question is successful
    if @question.update question_params
      # redirecting to the question show page
      redirect_to question_path(@question)
    else
      # rendering the edit form so the user can see the errors
      render :edit
    end
  end

  # DELETE /questions/:id (e.g. /questions/123)
  # this is used to delete a question from the database
  def destroy
    @question = Question.find params[:id]
    @question.destroy
    redirect_to questions_path
  end

end
