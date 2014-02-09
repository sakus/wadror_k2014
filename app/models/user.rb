class User < ActiveRecord::Base

	include RatingAverage
	
	has_secure_password

	has_many :ratings, dependent: :destroy
	has_many :beers, through: :ratings
	
	has_many :memberships, dependent: :destroy
	has_many :beer_clubs, through: :memberships

	validates :username, uniqueness: true, length: { minimum: 3, maximum: 15 }
	validates :password, format: { :with => /(?=.*[A-Z])(?=.*[0-9]).{4,}/ }

	def favorite_beer
		return nil if ratings.empty?
    	ratings.order(score: :desc).limit(1).first.beer
	end

	def favorite_style
		return nil if ratings.empty?

		style_averages = { "Weizen" => average_for_style("Weizen"), 
			"Lager" => average_for_style("Lager"), 
			"Pale Ale" => average_for_style("Pale Ale"), 
			"IPA" => average_for_style("IPA"), 
			"Porter" => average_for_style("Porter")}
		return style_averages.max_by{|k, v| v}[0]

	end

	def favorite_brewery
		return nil if ratings.empty?

		brewery_averages = Hash.new
		breweries = Brewery.all
		
		Brewery.all.each do |b|
			brewery_averages[b.name] = average_for_brewery(b.name)
		end

		return brewery_averages.max_by{|k, v| v}[0]
	end

	# returns the average score for all rated beers of the given brewery
	def average_for_brewery(brewery)
		count = 0
		sum = 0
		ratings.each do |r|
			if r.beer.brewery.name == brewery
				count = count + 1
				sum = sum + r.score
			end
		end
		if count > 0
			average = sum / count
			return average
		else
			return 0
		end
	end

	# returns the average score for all rated beers of the given style
	def average_for_style(style)
		count = 0
		sum = 0
		ratings.each do |r|
			if r.beer.style == style
				count = count + 1
				sum = sum + r.score
			end
		end
		if count > 0
			average = sum / count
			return average
		else
			return 0
		end
	end

end
