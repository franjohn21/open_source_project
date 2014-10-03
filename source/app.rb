require_relative 'config/application'

class Application
  def initialize
    @command_options = %w(list add delete complete tag filter quit exit help)
    parse_input(ARGV)
  end

  def parse_input(input)
    @command = input[0].split(":")[0]
    @option = input[0].split(":")[1]
    @argument = input.length > 1 ? input[1..-1].join(" ") : ""
    valid_input? ? proceed : get_new_input
  end

  def valid_input?
    return false unless @command_options.include?(@command)

    if @command == "list"
      return @option == nil || @option == "completed" || @option == "outstanding"
    elsif @command == "filter"
      return Tag.all.map(&:name).include?(@option)
    elsif @command == "delete" || @command == "complete" || @command == "tag"
      return Task.all.any? { |task| task.id == @argument.to_i }
    elsif @command == "help"
      puts
      puts "list<:status>   add <task>   delete <task_id>   complete <task_id>   tag <task_id> <tag(s)>   filter:<tag>   quit"
      true
    elsif @command == "quit" || @command == "exit"
      exit
    else
      true
    end
  end

  def get_new_input
    puts "\nInvalid command. Please try again ('help' for options):"
    print "> "
    new_input = $stdin.gets.chomp.split(" ")
    parse_input(new_input)
  end

  def proceed
    TasksController.route_input(@command, @option, @argument)
  end
end

Application.new

