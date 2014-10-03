require_relative '../../config/application'

class Controller
  # handle validation and processing of user input
  # carry out appropriate method calls

  def initialize
    @top_results = []
  end

  def run!

  end

  def execute(zipcode, category)
    
  end

  def bookmark(id, results)
    Bookmark.create(
      name: @top_results[:name],
      category: @top_results[:category],
      zipcode: @top_results[:zipcode],
      rating: @top_results[:rating]
    )
  end

  def remove_bookmark(id)
    Bookmark.destroy(id)
  end

  def query(zip_code)
    # get results from database
    return_top(all_results)
  end

  def return_top(all_results)
    @top_results = all_results.select { |result| result[:name][0].downcase == "m" }.sort_by(&:rating)[0..9]
    View.show_results(@top_results)
  end

  result = {name: name, category: category, zipcode: zipcode, rating: rating}

end
