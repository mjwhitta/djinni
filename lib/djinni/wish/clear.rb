class Djinni::Wish::Clear < Djinni::Wish
    def aliases
        return ["clear", "cls"]
    end

    def description
        return "Clear the screen"
    end

    def execute(args, djinni_env = {})
        system("clear") if (args.empty?)
        usage if (!args.empty?)
    end

    def usage
        puts aliases.join(", ")
        puts "    #{description}."
    end
end
