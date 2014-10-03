require_relative '../../config/application'

module View
  def self.start
    # welcome screen
    self.query_prompt
  end

  def self.query_prompt
    puts "\nEnter zipcode:"
    print "> "
    zipcode = gets.chomp.to_i

    puts "\nEnter category:"
    print "> "
    category = gets.chomp.downcase

    Controller.query(zipcode, category)
  end

  def self.show_results(results)
    self.headers
    results.each_with_index do |result, i|
      puts [
        "#{i + 1}".center(4, " "),
        " #{result[:name]}".ljust(40, " "),
        "#{result[:category]}".center(15, " "),
        "#{result[:zipcode]}".center(10, " "),
        "#{result[:rating]}".center(9, " ")
      ].join("|")
    end

    self.menu(results)
  end

  def self.headers
    puts [
     "##".center(4, " "),
     "Name".center(40, " "),
     "Category".center(15, " "),
     "Zipcode".center(10, " "),
     "Rating".center(9, " ")
    ].join("|")
    puts "-" * 82
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
