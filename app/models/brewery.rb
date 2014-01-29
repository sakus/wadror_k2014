class Brewery < ActiveRecord::Base

	include RatingAverage

 	@thisYear = lambda { return Time.now.year }.call

	has_many :beers, dependent: :destroy
	has_many :ratings, through: :beers

	validates :name, presence: true
	validates :year, numericality: { greater_than_or_equal_to: 1042,
                                    less_than_or_equal_to: @thisYear,
                                    only_integer: true }

end
