require "djinni"

class DjinniQuitWish < DjinniWish
    def aliases
        return [ "bye", "exit", "q", "quit" ]
    end

    def description
        return "Quit"
    end

    def execute(args, env = {})
        exit 0
    end

    def tab_complete(input, env = {})
        return input
    end

    def usage
        puts aliases.join(", ")
        puts "\t#{description}."
    end
end
