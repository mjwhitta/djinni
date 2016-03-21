class Djinni::Wish::Clear < Djinni::Wish
    def aliases
        return [ "clear", "cls" ]
    end

    def description
        return "Clear the screen"
    end

    def execute(args, djinni_env = {})
        if (args.nil? || args.empty?)
            system("clear")
        else
            usage
        end
    end

    def usage
        puts aliases.join(", ")
        puts "\t#{description}."
    end
end
