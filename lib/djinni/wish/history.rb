require "string"

class Djinni::Wish::History < Djinni::Wish
    def aliases
        return ["hist", "history"]
    end

    def description
        return "Show history or execute commands from history"
    end

    def execute(args, djinni_env = {})
        djinni = djinni_env["djinni"]
        history = djinni_env["djinni_history"]

        if (args.empty?)
            history.each_with_index do |hist, index|
                puts "#{index}:    #{hist}"
            end
            return
        end

        args.split(" ").each do |arg|
            case arg
            when "clear"
                # Do nothing
            when /^[0-9]+$/
                index = arg.to_i
                if ((index < 0) || (index >= history.length))
                    puts "Index out of bounds; #{index}"
                end
            else
                usage
                return
            end
        end

        args.split(" ").each do |arg|
            case arg
            when "clear"
                history.clear
            when /^[0-9]+$/
                index = arg.to_i
                print "\e[F"
                djinni.grant_wish("#{history[index]}\n", djinni_env)
            end
        end
    end

    def tab_complete(input, djinni_env = {})
        history = djinni_env["djinni_history"]
        input, last = input.rsplit(" ")
        included = input.split(" ")

        completions = Hash.new
        (0...history.length).each do |i|
            completions[i.to_s] = history[i]
        end
        completions["clear"] = "Clear history"

        completions.keep_if do |item, desc|
            !included.include?(item)
        end

        if (last && !last.empty?)
            completions.keep_if do |item, desc|
                item.downcase.start_with?(last.downcase)
            end
        end

        return [completions, last, " "]
    end

    def usage
        puts "history [option]"
        puts "    #{description}."
        puts "    OPTIONS"
        puts "        [0-9]+    Execute command from history"
        puts "        clear     Clear history"
    end
end
