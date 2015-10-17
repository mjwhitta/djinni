require "djinni"

class QuitWish < Djinni::Wish
    def aliases
        return [ "quit" ]
    end

    def description
        return "Quit with exit status 7"
    end

    def execute(args, djinni_env = {})
        exit 7
    end

    def usage
        puts aliases.join(", ")
        puts "\t#{description}."
    end
end
