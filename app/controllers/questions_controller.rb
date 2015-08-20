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

end
