require "djinni"

class Wish < DjinniWish
    def aliases
        return [ "quit" ]
    end

    def description
        return "Quit with exit status 7"
    end

    def execute(args, djinni_env = {})
        exit 7
    end

    def tab_complete(input, djinni_env = {})
        return input
    end

    def usage
        puts aliases.join(", ")
        puts "\t#{description}."
    end
end
