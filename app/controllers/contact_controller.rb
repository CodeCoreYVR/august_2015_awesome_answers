class ContactController < ApplicationController
  def index
  end

  def create
    @name = params[:name]
    @email = params[:email]
    # render text: "Thank you for contacting us!"
    # render :create, layout: "application"
  end
end
