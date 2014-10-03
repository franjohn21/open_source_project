require_relative '../../config/application'

module View
  def self.load
    self.welcome_screen
    self.user_continue
    self.main_menu
  end

  # TODO: welcome screen
  def self.welcome_screen
    self.clear_screen
    self.print_line
    puts "Welcome to Mmmmmmmmmm...".center(102, " ")
    self.print_line
  end

  def self.user_continue
    print "\n[ENTER to continue]"
    gets.chomp
  end

  # TODO: improve output; clear screen?
  def self.query_prompt
    self.clear_screen
    self.print_line
    puts "HMmmmmmmmmm...?".center(102, " ")
    self.print_line

    puts "\nEnter location:"
    print "> "
    location = gets.chomp
    exit! if location == ""
    $last_search_location = location

    puts "\nEnter search term:"
    print "> "
    term = gets.chomp.downcase
    exit! if term == ""

    category = get_category

    Controller.query(location, term, category)
  end

  def self.get_category
    categories = %w(Restaurants Bars Coffee Bakeries)
    puts "\nSelect category:"
    categories.each_with_index { |cat, i| puts " #{i + 1}. #{cat}" }
    print "> "
    input = gets.chomp.to_i
    exit! if input == 0
    unless (1..categories.length).include?(input)
      puts "\nInvalid input."
      get_category
    else
      categories[input - 1].downcase
    end
  end

  def self.show_results(results)
    self.clear_screen
    self.print_line
    puts "Here's what's Mmmmmmmmmm...".center(102, " ")
    self.headers
      begin

    if results.empty?
      puts "No results found"
    else
      results.each_with_index do |result, i|
      visited = Bookmark.any? { |bookmark| bookmark.yelp_id == result.id && bookmark.visited }
      puts [
        " #{i + 1}".center(4, " "),
        " #{result.name}".ljust(40, " "),
        "#{result.location.neighborhoods[0]}".center(24, " "),
        "#{result.review_count}".rjust(3, " ").center(11, " "),
        "#{result.rating}".center(9, " "),
        "#{'X' if visited}".center(9, " ")
      ].join("|")

     end
    end
    rescue
    puts "hMmmmmmmmmmm...? Could not find your address, please try again."
    end
    self.print_line

    self.results_menu(results)
  end

  def self.show_bookmarks(bookmarks = [])
    self.clear_screen
    self.print_line
    puts "BookMmmmmmmmmmarks".center(102, " ")
    self.headers
    bookmarks = Bookmark.all if bookmarks.empty?
    bookmarks.each_with_index do |bookmark, i|
      puts [
        " #{i + 1}".center(4, " "),
        " #{bookmark.name}".ljust(40, " "),
        "#{bookmark.neighborhood}".center(24, " "),
        "#{bookmark.reviews}".rjust(3, " ").center(11, " "),
        "#{bookmark.rating}".center(9, " "),
        "#{'X' if bookmark.visited?}".center(9, " ")
      ].join("|")
    end

    self.print_line

    self.bookmarks_menu(bookmarks)
  end

  def self.print_line
    puts "-" * 102
  end

  def self.clear_screen
    puts "\e[H\e[2J"
  end

  def self.headers
    self.print_line
    puts [
     "ID".center(4, " "),
     "Name".center(40, " "),
     "Neighborhood".center(24, " "),
     "Reviews".center(11, " "),
     "Rating".center(9, " "),
     "Visited".center(9, " ")
    ].join("|")
    self.print_line
  end

  # TODO: create separate main menu from results menu
  def self.main_menu
    self.clear_screen
    self.print_line
    puts "Mmmmmmmmmmenu".center(102, " ")
    self.print_line

    puts "\nWhat would you like to do?"
    puts " 1. Search"
    puts " 2. Show Bookmarks"
    puts " 3. Quit"
    print "> "
    input = gets.chomp
    command = input.split(" ")[0].to_i
    option = input.split(" ")[1].to_i

    case command
    when 1 then self.query_prompt
    when 2 then self.show_bookmarks
    when 3 then self.clear_screen; exit!
    else
      puts "\nInvalid command."
      self.user_continue
      self.main_menu
    end
  end

  def self.results_menu(results)
    puts "\nWhat would you like to do?"
    puts " 1. Search"
    puts " 2. View <id>"
    puts " 3. Bookmark <id>"
    puts " 4. Show Bookmarks"
    puts " 5. Quit"
    print "> "
    input = gets.chomp
    command = input.split(" ")[0].to_i
    option = input.split(" ")[1].to_i

    case command
    when 1 then self.query_prompt
    when 2 then self.view_result(results[option - 1], results)
    when 3 then Controller.bookmark(results[option - 1], results)
    when 4 then self.show_bookmarks
    when 5 then self.clear_screen; exit
    else
      puts "\nInvalid command."
      self.user_continue
      self.show_results(results)
      self.results_menu(results)
    end
  end

  def self.bookmarks_menu(bookmarks)
    puts "\nWhat would you like to do?"
    puts " 1. Search"
    puts " 2. Mark Bookmark as 'Visited' <id>"
    puts " 3. Remove Bookmark <id>"
    puts " 4. Quit"
    print "> "
    input = gets.chomp
    command = input.split(" ")[0].to_i
    option = input.split(" ")[1].to_i

    case command
    when 1 then self.query_prompt
    when 2 then Controller.mark_as_visited(bookmarks[option - 1])
    when 3 then Controller.remove_bookmark(bookmarks[option - 1])
    when 4 then self.clear_screen; exit
    else
      puts "\nInvalid command."
      self.user_continue
      self.show_bookmarks(bookmarks)
      self.bookmarks_menu(bookmarks)
    end
  end

  def self.view_result(result, results)
    self.clear_screen
    self.print_line
    puts "#{result.name}".center(102, " ")
    self.print_line

    origin = $last_search_location
    destination = result.location.display_address.join(", ")
    travel_time = Controller.get_travel_time(origin, destination)
    puts "\nTravel Time"
    puts "Walking: #{travel_time[:walking]} minutes"
    puts "Driving: #{travel_time[:driving]} minutes"
  end
end
