class Question < ActiveRecord::Base

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
      symbol        = "search_term_#{counter}".to_sym
      search_term   = "%#{word}%"
      terms << search_term
      terms << search_term
      query << "title ILIKE ? OR body ILIKE ?"
    end
    where([query.join(" OR ")] + terms)
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
