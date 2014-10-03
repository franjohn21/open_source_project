require_relative '../../config/application'

class Controller
  # handle validation and processing of user input
  # carry out appropriate method calls
  def self.run!

  end

  # TODO: update bookmark model
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

  def self.query(location, term, category)
    p location
    all_results = $yelp.search(location, {term: term, category_filter: category, sort: 2})
    return_top(all_results)
  end

  def self.return_top(all_results)
    m_results = all_results.businesses.select { |result| result.name[0].downcase == "m" }
    top_m_results = m_results.sort_by { |result| result.rating }[0..9].reverse
    # top_m_results = all_results.businesses.sort_by { |result| result.rating }[0..9].reverse
    View.show_results(top_m_results)
  end
end
