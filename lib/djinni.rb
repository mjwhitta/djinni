require "fagin"
require "io/console"

class Djinni
    attr_accessor :fallback

    def grant_wish(input, djinni_env = {})
        return "" if (input.nil? || input.empty?)

        djinni_env["djinni"] = self
        djinni_env["djinni_history"] = @history
        djinni_env["djinni_wishes"] = @wishes

        case input[-1]
        when "\x03" # ^C
            puts if (@interactive)
            return ""
        when "\x04" # ^D
            return "\x04"
        when "\x7F", "\b" # Backspace or ^H
            return input[0..-3]
        when "\f" # ^L
            system("clear") if (@interactive)
            return input[0..-2]
        when "\t" # Tab
            input = input[0..-2]
            if (input.include?(" "))
                name, args = input.split(" ", 2)
                return input if (!@wishes.has_key?(name))

                begin
                    wish = @wishes[name]
                    djinni_env["djinni_input"] = name
                    completions, replace, append = wish.tab_complete(
                        args,
                        djinni_env
                    )
                rescue SystemExit => e
                    raise e
                rescue Exception => e
                    puts
                    puts e.message
                ensure
                    append ||= " "
                    completions ||= Hash.new
                    replace ||= ""
                end

                return input if (completions.empty?)

                if (completions.length == 1)
                    return input.gsub(
                        /#{replace}$/,
                        "#{completions.first.first}#{append}"
                    )
                end

                puts
                max = completions.keys.max_by(&:length).length
                completions.each do |item, desc|
                    fill = Array.new(max + 4 - item.length, " ").join
                    nlfill = Array.new(max + 4, " ").join
                    lines = desc.scan(
                        /\S.{0,#{80 - (max + 4)}}\S(?=\s|$)|\S+/
                    )

                    if (lines.empty?)
                        puts "#{item}"
                    else
                        start = lines.delete_at(0)
                        puts "#{item}#{fill}#{start}"
                        lines.each do |line|
                            puts "#{nlfill}#{line}"
                        end
                    end
                end

                return input.gsub(
                    /#{replace}$/,
                    longest_common_substring(completions.keys)
                )
            else
                wishes = @wishes.select do |aliaz, w|
                    aliaz.start_with?(input)
                end

                return input if (wishes.empty?)

                if (wishes.length == 1)
                    return "#{wishes.first.first} "
                end

                puts
                max = wishes.keys.max_by(&:length).length
                wishes.sort do |a, b|
                    a.first.downcase <=> b.first.downcase
                end.each do |aliaz, w|
                    fill = Array.new(max + 4 - aliaz.length, " ").join
                    nlfill = Array.new(max + 4, " ").join
                    lines = w.description.scan(
                        /\S.{0,#{80 - (max + 4)}}\S(?=\s|$)|\S+/
                    )

                    if (lines.empty?)
                        puts "#{aliaz}"
                    else
                        start = lines.delete_at(0)
                        puts "#{aliaz}#{fill}#{start}"
                        lines.each do |line|
                            puts "#{nlfill}#{line}"
                        end
                    end
                end

                return longest_common_substring(wishes.keys)
            end
        when /\r|\n/ # Enter
            input.strip!
            puts if (@interactive)
            return "" if (input.empty?)

            # "".split(" ", 2) => [] aka [nil, nil]
            # " ".split(" ", 2) => [""] aka ["", nil]
            # The above 2 would return before getting here
            # "string".split(" ", 2) => ["string"] aka ["string", nil]
            # "string ".split(" ", 2) => ["string", ""]
            name, args = input.split(" ", 2)
            args ||= ""

            @wishes.select do |aliaz, w|
                aliaz == name
            end.each do |aliaz, w|
                begin
                    djinni_env["djinni_input"] = name
                    w.execute(args, djinni_env)
                rescue SystemExit => e
                    raise e
                rescue Exception => e
                    puts e.message
                end

                if (w.class.to_s != "Djinni::Wish::History")
                    store_history(input)
                end

                return ""
            end
            store_history(input)
            return nil
        when "\e" # Arrow keys
            code = "\e"
            t = Thread.new do
                code += STDIN.getch + STDIN.getch
            end
            t.join(0.001) if (t)
            t.kill if (t)

            case code
            when /\e[\[O]A/ # Up arrow
                return "" if (@history.empty?)
                @hist_index = @history.size if (@hist_index.nil?)
                @hist_index = 1 if (@hist_index == 0)
                @hist_index -= 1
                return @history[@hist_index]
            when /\e[\[O]B/ # Down arrow
                @hist_index = @history.size if (@hist_index.nil?)
                @hist_index += 1
                if (@hist_index < @history.size)
                    return @history[@hist_index]
                else
                    @hist_index = @history.size
                    return ""
                end
            when /\e[\[O]C/ # Right arrow
                # TODO maybe implement right arrow
                return input[0..-2]
            when /\e[\[O]D/ # Left arrow
                # TODO maybe implement left arrow
                return input[0..-2]
            else
                return input[0..-2]
            end
        else
            return input
        end
    end

    def initialize(interactive = false)
        @fallback = nil
        @hist_index = nil
        @history = Array.new
        @interactive = interactive
        @loaded_from = Array.new
        @width = %x(tput cols).to_i
        @wishes = Hash.new

        Signal.trap(
            "SIGWINCH",
            proc do
                @width = %x(tput cols).to_i
            end
        )

        load_wishes("#{File.dirname(__FILE__)}/djinni/wish")
    end

    def load_wishes(dir)
        return if @loaded_from.include?(dir)

        classes = Fagin.find_children("Djinni::Wish", dir)
        classes.each do |clas, wish|
            w = wish.new
            w.aliases.each do |aliaz|
                @wishes[aliaz] = w
            end
        end

        @loaded_from.push(dir)
    end

    def longest_common_substring(array)
        compare = array.min_by(&:length)
        loop do
            break if (compare.empty?)
            all = array.all? do |item|
                item.downcase.start_with?(compare.downcase)
            end
            compare = compare[0..-2] if (!all)
            break if (all)
        end
        return compare
    end
    private :longest_common_substring

    def prompt(djinni_env = {}, djinni_prompt = "$ ")
        @interactive = true

        djinni_env["djinni_prompt"] = djinni_prompt
        prev_len = 0
        buff = ""
        loop do
            djinni_prompt = djinni_env["djinni_prompt"]
            blank_line = Array.new(@width, " ").join

            # Handle long lines that get wrapped
            buff_len = remove_colors(djinni_prompt).length + prev_len
            lines = buff_len / @width
            lines -= 1 if ((buff_len % @width) == 0)
            lines.times do
                print "\r#{blank_line}"
                print "\e[F"
            end

            # Redisplay prompt
            print "\r#{blank_line}"
            print "\r#{djinni_prompt}#{buff}"

            # Process input
            input = nil
            system("stty raw -echo")
            while (input.nil?)
                begin
                    input = STDIN.getch
                rescue
                    puts if (@interactive)
                end
            end
            system("stty -raw echo")
            prev_len = remove_colors(buff).length
            save = buff
            buff = grant_wish(buff + input, djinni_env)

            if (buff.nil? && !@fallback.nil? && !@fallback.empty?)
                puts "\e[2A"
                buff = grant_wish(
                    @fallback + " " + save + input, djinni_env
                )
            end

            if (buff.nil?)
                puts "Command not found!"
                buff = ""
            end

            # Exit on ^D
            if (buff == "\x04")
                return
            end
        end
    end

    def remove_colors(str)
        str.unpack("C*").pack("U*").gsub(/\e\[([0-9;]*m|K)/, "")
    end
    private :remove_colors

    def store_history(input)
        # Only keep newest wish if repeat
        # @history.delete(input)

        @history.push(input)
        @hist_index = nil
    end
    private :store_history
end

require "djinni/error"
require "djinni/wish"
