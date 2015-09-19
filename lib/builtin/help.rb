require "djinni"

class DjinniHelpWish < DjinniWish
    def aliases
        return [ "?", "help" ]
    end

    def description
        return "Show helpful information for a wish or wishes"
    end

    def execute(args, env = {})
        if (args.nil? || args.empty?)
            env["djinni_wishes"].sort.map do |aliaz, wish|
                puts "#{aliaz}\t#{wish.description}"
            end
        elsif (args.split(" ").length == 1)
            env["djinni_wishes"].sort.map do |aliaz, wish|
                if (aliaz == args)
                    wish.usage
                    return
                end
            end
            puts "Wish #{args} not found!"
        else
            usage
        end
    end

    def tab_complete(input, env = {})
        return input
    end

    def usage
        puts "help [wish]"
        puts "\tPrint usage for specified wish. If no wish is"
        puts "\tspecified, print description of all wishes."
    end
end
