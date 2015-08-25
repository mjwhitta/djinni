require "djinni"

class ClearWish < DjinniWish
    def aliases
        return [ "clear", "cls" ]
    end

    def description
        return "Clear the screen"
    end

    def execute(args)
        system("clear")
    end

    def tab_complete(input)
        return input
    end
end
