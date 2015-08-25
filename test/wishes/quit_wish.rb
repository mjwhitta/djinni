require "djinni"

class QuitWish < DjinniWish
    def aliases
        return [ "bye", "exit", "q", "quit" ]
    end

    def description
        return "Exit"
    end

    def execute(args)
        exit 0
    end

    def tab_complete(input)
        return input
    end
end
