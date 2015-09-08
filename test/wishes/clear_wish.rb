require "djinni"

class ClearWish < DjinniWish
    def aliases
        return [ "clear", "cls" ]
    end

    def description
        return "Clear the screen"
    end

    def execute(args, env = {})
        system("clear")
    end

    def tab_complete(input, env = {})
        return input
    end

    def usage
        puts aliases.join(", ")
        puts "\t#{description}."
    end
end
