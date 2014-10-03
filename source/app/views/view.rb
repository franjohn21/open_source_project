module View
  # show prompt
  # command-line output of query results
  # pass input to controller
  # Controller.execute_comand(input)

  def self.startup
    # welcome screen
    self.query_prompt
  end

  def self.query_prompt
    puts "Enter zipcode:"
    print "> "
    zipcode = gets.chomp

    puts "Enter category:"
    print "> "
    category = gets.chomp

    c.query(zipcode, category)
  end

  def self.show_results(results)
    p results
    self.menu
  end

  def self.menu
    puts "What would you like to do next?"
    puts "1. Run another search"
    puts "2. Bookmark <id>"
    input = gets.chomp

    if input.include?("2")
      c.Bookmark(arguments)
    elsif input == 1
      self.query_prompt
    else
      # error message
     end
  end


end
