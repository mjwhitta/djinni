require "djinni"

class LSWish < Djinni::Wish
    def aliases
        return [ "dir", "ll", "ls" ]
    end

    def description
        return "List directory contents"
    end

    def execute(args, djinni_env = {})
        # djinni_env["djinni"] - Djinni
        #     Contains the calling djinni object
        # djinni_env["djinni_history"] - Array
        #     Contains previous wishes
        # djinni_env["djinni_input"] - String
        #     Contains which alias was used
        # djinni_env["djinni_prompt"] - String
        #     If Djinni.prompt was called, as opposed to
        #     Djinni.grant_wish, then this contains the prompt string
        #     presented to the user
        # djinni_env["djinni_wishes"] - Hash
        #     Contains available wishes
        #
        case djinni_env["djinni_input"]
        when "ll"
            puts %x(ls -hl #{args})
        else
            puts %x(ls #{args})
        end
    end

    def tab_complete(input, djinni_env = {})
        included = input.split(" ")
        completions = Dir["*"].delete_if do |item|
            included.include?(item)
        end.sort
        completions.insert(0, "-l")

        if (input.empty? || input.end_with?(" "))
            puts
            puts completions.sort
            return input
        end

        completions.each do |item|
            if (item.downcase.start_with?(included[-1].downcase))
                included[-1] = item
                return included.join(" ")
            end
        end

        puts
        puts completions
        return input
    end

    def usage
        puts "#{aliases.join(", ")} [-l] [dir1/file1]..[dirN/fileN]"
        puts "\t#{description}."
    end
end
