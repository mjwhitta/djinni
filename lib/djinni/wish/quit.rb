class Djinni::Wish::Quit < Djinni::Wish
    def aliases
        return [ "bye", "exit", "q", "quit" ]
    end

    def description
        return "Quit"
    end

    def execute(args, djinni_env = {})
        exit 0
    end

    def usage
        puts aliases.join(", ")
        puts "\t#{description}."
    end
end
