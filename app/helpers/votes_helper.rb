module VotesHelper

  def current_user_vote
    # memoization - the first time it will make a call to the database, the
    # second time it will just use the instance variable so not second call to
    # the database happens
    @current_user_vote ||= current_user.votes.find_by_question_id @question.id
  end
  # helper_method :current_user_vote
  # adding the helper_method call here, makes this method accessible in the views


end
