require "djinni"

class LSWish < DjinniWish
    def aliases
        return [ "ls", "dir" ]
    end

    def description
        return "List directory contents"
    end

    def execute(args, djinni_env = {})
        puts %x(ls #{args})
    end

    def tab_complete(input, djinni_env = {})
        included = input.split(" ")
        completions = Array.new
        completions.push("-l")
        Dir["*"].each do |item|
            completions.push(item)
        end
        included.each do |item|
            completions.delete(item)
        end

        if (input.empty? || input.end_with?(" "))
            puts
            puts completions.sort
            return input
        end

        completions.sort.each do |item|
            if (item.downcase.start_with?(included[-1].downcase))
                included[-1] = item
                return included.join(" ")
            end
        end

        puts
        puts completions.sort
        return input
    end

    def usage
        puts "#{aliases.join(", ")} [-l] [dir1/file1]..[dirN/fileN]"
        puts "\t#{description}."
    end
end
