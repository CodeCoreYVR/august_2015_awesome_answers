class WelcomeController < ApplicationController

  # setting the layout in here changes the default layout for
  # all the actions in this controller.
  # layout "special"


  def index
    # this will just send a plain text response back to the client
    # render({text: "Hello World"})
    # render text: "Hello World"

    # Rails automatically renders a template with the views subfolder matching
    # the controllers name. In this case the welcome folder. It will look for a
    # file named index with the approperiate format and templating language
    # so we can write this but it's redundant:
    # render(:index, {layout: "application"})

    # to render using alternative layout you can do:
    # render :index, layout: "special"

    # Every controller action must have a single render or a single redirect
  end

  def hello
    @name = params[:name]
  end
end
