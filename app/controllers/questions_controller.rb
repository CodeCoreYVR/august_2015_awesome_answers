class QuestionsController < ApplicationController

  before_action :authenticate_user!, except: [:show, :index]

  PER_PAGE = 10
  # the before action takes in a required first argument which references a method
  # that will be executed before every action. You can give it a second arguement
  # which is a hash, possible keys are :only and :except if you want to restrict
  # the method calls to specific actions
  # before_action :find_question, except: [:index, :new, :create]
  before_action :find_question, only: [:show, :edit, :update, :destroy, :lock]

  before_action :authorize!, only: [:edit, :update, :destroy]

  # the new action is the one that is used by convention in Rails to display
  # a form to create the record (in this case question record)
  def new
    # We instantiate an instance variable of the object we'd like to create in
    # order to use the `form_for` helper method in Rails to easily generate
    # a form that submits to the create action
    @question = Question.new # Question.new(title: "hello")
  end

  def create
    @question      = Question.new(question_params)
    @question.user = current_user
    Rails.logger.info ">>>>>"
    if @question.save
      # flash[:notice] = "Question created!"
      # passing :notice / :alert only works for redirect
      redirect_to question_path(@question), notice: "Question created!"
    else
      flash[:alert] = "See errors below"
      render :new
    end
  end

  # GET /questions/:id (e.g. /questions/1)
  # this is used to show a page with question information
  def show
    respond_to do |format|
      @answer = Answer.new
      format.html { render }
      format.json { render json: {question: @question, answers: @question.answers} }
      format.xml  { render xml: @question }
    end
  end

  # GET /questions
  # this is used to show a page with listing of all the questions in our DB
  def index
    per_page = params[:per_page] || PER_PAGE
    if params[:search]
      @questions = Question.search(params[:search]).order("#{params[:order]}").page(params[:page]).per(per_page)
    else
      @questions = Question.order("#{params[:order]}").page(params[:page]).per(per_page)
    end
    respond_to do |format|
      format.json { render json: @questions }
      format.html { render  }
    end
    # @question = Question.new
  end

  # GET /questions/:id/edit (e.g. /questions/123/edit )
  # this is used to show a form to edit and submit to update a question in the database
  def edit
  end

  # PATCH /questions/:id (e.g. /questions/123)
  # this is used to handle the submission of the question form from the edit page
  # when user is updating the information on a question
  def update
    @question.slug = nil
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
    @question.destroy
    redirect_to questions_path
  end

  def lock
    # this toggles the value of locked between true and false
    @question.locked = !@question.locked
    @question.save
    redirect_to question_path(@question)
  end

  private

  def find_question
    @question = Question.friendly.find params[:id]
  end

  def authorize!
    # head :unauthorized unless can? :manage, @question
    redirect_to root_path, alert: "access denied" unless can? :manage, @question
  end

  def question_params
    # params[:question] => {title: "Abc", body: "xyz"}
    # params.require ensures that the params hash has a key :question and
    # fetches all the attributes from that hash. the .permit only allows
    # the parameters given to be mass-assigned
    # question_params = params.require(:question).permit([:title, :body])
    # question_params =>  {title: "Abc", body: "xyz"}
    params.require(:question).permit([:title, :body, :image,
                                     {tag_ids: []},
                                     :locked, :category_id])
  end

end
