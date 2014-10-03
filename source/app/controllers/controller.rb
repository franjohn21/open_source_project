require_relative '../../config/application'

class Controller
  # handle validation and processing of user input
  # carry out appropriate method calls
  def self.run!

  end

  def self.execute(zipcode, category)
    
  end

  def self.bookmark(selection)
    Bookmark.create(
      name: selection[:name],
      category: selection[:category],
      zipcode: selection[:zipcode],
      rating: selection[:rating]
    )
  end

  def self.remove_bookmark(id)
    Bookmark.destroy(id)
  end

  def self.query(zipcode, category)
    # get results from database
    all_results = self.api(zipcode, category)
    return_top(all_results)
  end

  def self.return_top(all_results)
    all_results
    m_results = all_results.select { |result| result[:name][0].downcase == "m" }
    top_m_results = m_results.sort_by { |result| result[:rating] }[0..9]
    View.show_results(top_m_results)
  end

  def self.api(zipcode, category)
    all_results = []
    categories = %w(Restaurants Bars Nightlife Shopping Hotels)
    zipcodes = [12345, 23456, 34567, 45678]
    ratings = [1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0]
    100.times do
      all_results << {
        name: "M" + Faker::Company.name,
        category: categories.sample,
        zipcode: zipcodes.sample,
        rating: ratings.sample
      }
    end

    all_results.select { |result| result[:category].downcase == category && result[:zipcode] == zipcode }
  end

end
