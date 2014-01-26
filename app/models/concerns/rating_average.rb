module RatingAverage

	extend ActiveSupport::Concern
	
	def average_rating
		ratings = self.ratings.count
		total = self.ratings.each.inject(0) { |sum, e| sum + e.score }
		return "Has #{ratings} #{"rating".pluralize(ratings)}, average #{total/ratings}"
	end

end
