require "djinni"

class DjinniHistoryWish < Djinni::Wish
    def aliases
        return [ "hist", "history" ]
    end

    def description
        return "Show history or execute commands from history"
    end

    def execute(args, djinni_env = {})
        djinni = djinni_env["djinni"]
        history = djinni_env["djinni_history"]

        case args
        when nil, ""
            history.each_index do |index|
                puts "#{index}:\t#{history[index]}"
            end
        when "clear"
            history.clear
        when %r{^[0-9]+( [0-9]+)*$}
            args.split(" ").each do |arg|
                index = arg.to_i
                if ((index >= 0) && (index < history.length))
                    djinni.grant_wish(
                        "#{history[index]}\n",
                        djinni_env
                    )
                else
                    puts "Index out of bounds"
                end
            end
        else
            usage
        end
    end

    def tab_complete(input, djinni_env = {})
        history = djinni_env["djinni_history"]

        included = input.split(" ")
        completions = (0...history.length).to_a

        included.each do |item|
            completions.delete(item.to_i)
        end

        if (input.empty? || input.end_with?(" "))
            puts
            completions.sort.each do |index|
                puts "#{index}:\t#{history[index]}"
            end
            return input
        end

        return "#{input} "
    end

    def usage
        puts "history [option]"
        puts "\t#{description}."
        puts "\tOPTIONS"
        puts "\t\t[0-9]+\tExecute command from history"
        puts "\t\tclear\tClear history"
    end
end
