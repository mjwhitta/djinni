require "djinni"

class IDWish < DjinniWish
    def aliases
        return [ "id", "me" ]
    end

    def description
        return "Show uid, gid, and groups"
    end

    def execute(args)
        puts %x(id #{args})
    end

    def tab_complete(input)
        return input
    end
end

class WhoamiWish < DjinniWish
    def aliases
        return [ "whoami", "who" ]
    end

    def description
        return "Show username"
    end

    def execute(args)
        puts %x(whoami #{args})
    end

    def tab_complete(input)
        return input
    end
end
