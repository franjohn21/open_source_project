require_relative '../../config/application'

module Controller
  def self.run!
    View.load
  end

  def self.bookmark(selection, results)
    if Bookmark.any? { |bookmark| bookmark.yelp_id == selection.id }
      puts "\nYou've already bookmarked that!"
    else
      Bookmark.create(
        name: selection.name,
        neighborhood: selection.location.neighborhoods[0],
        reviews: selection.review_count,
        rating: selection.rating,
        yelp_id: selection.id
      )
      puts "\nBookmarked #{selection.name}!"
    end

    View.user_continue
    View.main_menu
  end

  def self.mark_as_visited(bookmark)
    bookmark.update_attribute(:visited, true)
    puts "Marked #{bookmark.name} as 'visited'!"
    # TODO: add hook to main menu
  end

  def self.remove_bookmark(bookmark)
    puts "Removed #{bookmark.name} from bookmarks."
    bookmark.destroy

    View.user_continue
    View.main_menu
  end

  def self.query(location, term, category)
    all_results = $yelp.search(location, {term: term, category_filter: category, sort: 2})
    return_top(all_results)
  end

  def self.return_top(all_results)
    # m_results = all_results.businesses.select { |result| result.name[0].downcase == "m" }
    # top_m_results = m_results.sort_by { |result| result.rating }[0..9].reverse
    top_m_results = all_results.businesses.sort_by { |result| result.rating }[0..9].reverse

    View.show_results(top_m_results)
  end

  def self.get_travel_time(origin, destination)
    walking = GoogleDirections.new(origin, destination, {:mode => :walking})
    driving = GoogleDirections.new(origin, destination)
    {:walking => walking.drive_time_in_minutes, :driving => driving.drive_time_in_minutes}
  end
end
