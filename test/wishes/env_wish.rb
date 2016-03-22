require "djinni"
require "json"

class EnvWish < Djinni::Wish
    def aliases
        return ["env", "ENV"]
    end

    def description
        return "Show djinni environment"
    end

    def execute(args, djinni_env = {})
        puts JSON.pretty_generate(djinni_env)
    end

    def usage
        puts "#{aliases.join(", ")}"
        puts "    #{description}."
    end
end
