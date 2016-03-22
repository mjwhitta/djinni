require "djinni"
require "string"

class LSWish < Djinni::Wish
    def aliases
        return ["dir", "ll", "ls"]
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

        case djinni_env["djinni_input"]
        when "ll"
            puts %x(ls -hl #{args})
        else
            puts %x(ls #{args})
        end
    end

    def tab_complete(input, djinni_env = {})
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

        input, last = input.rsplit(" ")
        included = input.split(" ")
        completions = Hash.new

        if (djinni_env["djinni_input"] != "ll")
            if (!included.include?("-l"))
                completions["-l"] = "Use a long listing format"
            end
        end

        # This is only an example so only complete current directory
        Dir["*"].select do |item|
            !included.include?(item)
        end.sort do |a, b|
            a.downcase <=> b.downcase
        end.each do |item|
            completions[item] = %x(
                \ls -dhl #{item} | awk '{print $1,$3,$4,$5,$6,$7,$8}'
            )
        end

        if (last && !last.empty?)
            completions.keep_if do |item, desc|
                item.downcase.start_with?(last.downcase)
            end
        end

        return [completions, last, " "]
    end

    def usage
        puts "#{aliases.join(", ")} [-l] [dir1/file1]..[dirN/fileN]"
        puts "    #{description}."
    end
end
