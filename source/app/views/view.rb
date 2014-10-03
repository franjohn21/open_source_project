require_relative '../../config/application'

module View
  def self.start
    # TODO: welcome screen
    self.query_prompt
  end

  # TODO: improve output; clear screen?
  def self.query_prompt
    puts "\nEnter location:"
    print "> "
    location = gets.chomp

    puts "\nEnter search term:"
    print "> "
    term = gets.chomp.downcase

    puts "\nEnter category:"
    print "> "
    category = gets.chomp.downcase

    Controller.query(location, term, category)
  end

  def self.show_results(results)
    self.headers
    results.each_with_index do |result, i|
      puts [
        " #{i + 1}".center(4, " "),
        " #{result.name}".ljust(40, " "),
        "#{result.location.neighborhoods[0]}".center(24, " "),
        "#{result.review_count}".center(11, " "),
        "#{result.rating}".center(9, " ")
      ].join("|")
    end

    self.menu(results)
  end

  def self.headers
    puts [
     "##".center(4, " "),
     "Name".center(40, " "),
     "Neighborhood".center(24, " "),
     "Reviews".center(11, " "),
     "Rating".center(9, " ")
    ].join("|")
    puts "-" * 91
  end

  def self.menu(results)
    puts "\nWhat would you like to do next?"
    puts " 1. Run another search"
    puts " 2. Bookmark <id>"
    puts " 3. Quit"
    print "> "
    input = gets.chomp
    command = input.split(" ")[0].to_i
    option = input.split(" ")[1].to_i

    case command
    when 1 then self.query_prompt
    when 2 then Controller.bookmark(results[option - 1])
    when 3 then exit
    else
      puts "Invalid command."
      self.menu(results)
    end
  end


end
