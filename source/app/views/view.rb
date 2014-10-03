require_relative '../../config/application'

module View
  def self.start
    # welcome screen
    self.query_prompt
  end

  def self.query_prompt
    puts "Enter zipcode:"
    print "> "
    zipcode = gets.chomp.to_i

    puts "Enter category:"
    print "> "
    category = gets.chomp.downcase

    Controller.query(zipcode, category)
  end

  def self.show_results(results)
    results.each_with_index { |result, i| puts "#{i + 1}. ".rjust(4, " ") + result[:name] }
    self.menu(results)
  end

  def self.menu(results)
    puts "What would you like to do next?"
    puts " 1. Run another search"
    puts " 2. Bookmark <id>"
    puts " 3. Quit"
    input = gets.chomp
    command = input.split(" ")[0].to_i
    option = input.split(" ")[1].to_i

    case command
    when 1 then self.query_prompt
    when 2 then c.bookmark(results[option - 1])
    when 3 then exit
    else
      puts "Invalid command."
      self.menu(results)
    end
  end


end
