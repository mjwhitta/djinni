class Djinni::Wish::Help < Djinni::Wish
    def aliases
        return ["?", "help"]
    end

    def description
        return "Show helpful information for a command or commands"
    end

    def execute(args, djinni_env = {})
        wishes = djinni_env["djinni_wishes"]
        max = wishes.keys.max_by(&:length).length
        if (args.empty?)
            fill = Array.new(max - 7 + 4, " ").join
            puts "COMMAND#{fill}DESCRIPTION"
            puts "-------#{fill}-----------"
            wishes.sort do |a, b|
                a.first.downcase <=> b.first.downcase
            end.each do |aliaz, wish|
                fill = Array.new(max - aliaz.length + 4, " ").join
                puts "#{aliaz}#{fill}#{wish.description}"
            end
        elsif (args.split(" ").length == 1)
            wishes.sort do |a, b|
                a.first.downcase <=> b.first.downcase
            end.each do |aliaz, wish|
                if (aliaz == args)
                    wish.usage
                    return
                end
            end
            puts "Command #{args} not found!"
        else
            usage
        end
    end

    def tab_complete(input, djinni_env = {})
        return [{}, "", " "] if (input.include?(" "))

        completions = Hash.new
        djinni_env["djinni_wishes"].select do |aliaz, wish|
            aliaz.downcase.start_with?(input.downcase)
        end.sort do |a, b|
            a.first.downcase <=> b.first.downcase
        end.each do |aliaz, wish|
            completions[aliaz] = wish.description
        end

        return [completions, input, " "]
    end

    def usage
        puts "help [command]"
        puts "    Print usage for specified command. If no command is"
        puts "    specified, print description of all commands."
    end
end
