class Question < ActiveRecord::Base

  #  has_many :answers assumes that you have a model Answer that has a reference
  # to theis model (Question) called question_id (Integer)
  # the dependent option is needed because we've added a foreign key Contraint
  # to our database so the dependent records (in this case answers) must do
  # something before deleting a question that they reference. the options are:
  # :destroy -> will delete all the answers referencing this question before
  #             deleting the question
  # :nullify -> will make question_id field null in the database before deleting
  #             the quesiton
  has_many :answers, dependent: :destroy
  has_many :comments, through: :answers

  has_many :likes, dependent: :destroy
  has_many :liking_users, through: :likes, source: :user

  has_many :favourites, dependent: :destroy
  has_many :favouriting_users, through: :favourites, source: :user

  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  has_many :votes, dependent: :destroy
  has_many :voters, through: :votes, source: :user

  belongs_to :category

  belongs_to :user

  mount_uploader :image, ImageUploader

  # this prevents the record from saving or updating unless a title is provided
  validates :title, presence:   {message: "must be present"},
                    # this will check for the uniqueness of the tite/body
                    # combination. So title doesn't have to be unique by itself
                    # but the combination with body should.
                    uniqueness: {scope: :body},
                    length:     {minimum: 3} # title must have at least 3 chars

  validates(:body, {presence: true})

  # numericality validates that the provided field is a number you can give it:
  # greater_than, greater_than_or_equal_to, less_than, less_than_or_equal_to
  validates :view_count, presence:     true,
                         numericality: {greater_than_or_equal_to: 0}

  # if you had an email attribute you can validate the format of the attribute
  # using the `format` option, it takes a regular expression
  # validates :email, format: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  # we use validate if we want to have a custom validation method that we can
  # have any kind of Ruby code in.
  validate :no_monkey

  after_initialize :set_defaults

  before_save :capitalize_title

  extend FriendlyId
  friendly_id :title, use: [:slugged, :history]

  # def to_param
  #   "#{id}-#{title}".parameterize
  # end

  scope :recent, lambda { order(:created_at).reverse_order }
  scope :recent, -> { order(:created_at).reverse_order }
  def self.recent
    order(:created_at).reverse_order
  end

  def self.ten
    limit(10)
  end

  def self.recent_ten
    recent.ten
  end

  def self.search(item)
    # thing = "%#{item}%"
    # where(["title ILIKE ? OR body ILIKE ?", thing, thing])

    search_term = "%#{item}%"
    # where("title || ' ' || body ILIKE ? ", search_term)
    where(["title ILIKE :term OR body ILIKE :term", {term: search_term}])
  end

  def self.search_multiple(words)
    query   = []
    terms   = []
    words.split.each do |word|
      search_term   = "%#{word}%"
      terms << search_term
      terms << search_term
      query << "title ILIKE ? OR body ILIKE ?"
    end
    where([query.join(" OR ")] + terms)
  end

  def user_name
    if user
      user.full_name
    else
      "Anonymous"
    end
  end

  # delegate :name, to: :category # @question.name
  delegate :name, to: :category, prefix: true # @question.category_name
  # def category_name
  #   category.name
  # end

  def like_for(user)
    likes.find_by_user_id(user.id)
  end

  def favourite_for(user)
    favourites.find_by_user_id(user.id)
  end

  def votes_count
    votes.select {|v| v.up? }.count - votes.select {|v| v.down? }.count
  end

  private

  def no_monkey
    if title.present? && title.downcase.include?("monkey")
      # this will add to the errors object attached to the current object.
      # if the errors object is not an empty Hash then rails treats the
      # record as invalid
      errors.add(:title, "can't have monkey!")
    end
  end

  def set_defaults
    self.view_count ||= 0
  end

  def capitalize_title
    # self.title.capitalize!
    self.title = title.capitalize
  end

end



#
# module HandyMethods
#
#   def say_hello
#     puts "Hello There"
#   end
#
# end
#
# class Abc
#   include HandyMethods
#   # as if you did:
#   # def say_hello
#   #   puts "Hello There"
#   # end
# end
# # a = Abc.new
# # a.say_hello
#
# class Xyz
#   extend HandyMethods
#   # as if you did:
#   # def self.say_hello
#   #   puts "Hello There"
#   # end
# end
# # Xyz.say_hello
