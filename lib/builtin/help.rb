require "djinni"

class DjinniHelpWish < DjinniWish
    def aliases
        return [ "?", "help" ]
    end

    def description
        return "Show helpful information for a wish or wishes"
    end

    def execute(args, djinni_env = {})
        wishes = djinni_env["djinni_wishes"].sort
        if (args.nil? || args.empty?)
            cmd_col_width = 0
            wishes.map do |aliaz, wish|
                if (aliaz.length > cmd_col_width)
                    cmd_col_width = aliaz.length
                end
            end

            filler = Array.new(cmd_col_width - 7 + 4, " ").join
            puts "COMMAND#{filler}DESCRIPTION"
            puts "-------#{filler}-----------"
            wishes.map do |aliaz, wish|
                filler = Array.new(
                    cmd_col_width - aliaz.length + 4,
                    " "
                ).join
                puts "#{aliaz}#{filler}#{wish.description}"
            end
        elsif (args.split(" ").length == 1)
            wishes.map do |aliaz, wish|
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

    def tab_complete(input, djinni_env = {})
        return input
    end

    def usage
        puts "help [wish]"
        puts "\tPrint usage for specified wish. If no wish is"
        puts "\tspecified, print description of all wishes."
    end
end
