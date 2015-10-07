require "djinni"
require "json"

class EnvWish < DjinniWish
    def aliases
        return [ "env" ]
    end

    def description
        return "Show djinni environment"
    end

    def execute(args, djinni_env = {})
        puts JSON.pretty_generate(djinni_env)
    end

    def usage
        puts "#{aliases.join(", ")}"
        puts "\t#{description}."
    end
end
