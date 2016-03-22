require "djinni"

class IDWish < Djinni::Wish
    def aliases
        return ["id", "ID", "me"]
    end

    def description
        return "Show uid, gid, and groups"
    end

    def execute(args, djinni_env = {})
        puts %x(id #{args})
    end

    def usage
        puts aliases.join(", ")
        puts "    #{description}."
    end
end

class WhoamiWish < Djinni::Wish
    def aliases
        return [ "whoami", "who" ]
    end

    def description
        return "Show username"
    end

    def execute(args, djinni_env = {})
        puts %x(whoami #{args})
    end

    def usage
        puts aliases.join(", ")
        puts "    #{description}."
    end
end
