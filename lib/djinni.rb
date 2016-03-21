require "fagin"
require "io/console"
require "terminfo"

class Djinni
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
        when "\x7F" # Backspace
            return input[0..-3]
        when "\f" # ^L
            system("clear") if (@interactive)
            return input[0..-2]
        when "\t" # Tab
            input = input[0..-2]
            if (input.include?(" "))
                name, args = input.split(" ", 2)
                return input if (!@wishes.has_key?(name))

                wish = @wishes[name]
                complete = ""
                begin
                    djinni_env["djinni_input"] = input
                    complete = wish.tab_complete(args, djinni_env)
                rescue SystemExit => e
                    raise e
                rescue Exception => e
                    puts
                    puts e.message
                end
                return "#{name} #{complete}"
            else
                wishes = @wishes.keys
                wishes.sort.each do |wish|
                    if (wish.start_with?(input))
                        return "#{wish} "
                    end
                end
                return input
            end
        when /\r|\n/ # Enter
            input.strip!
            puts if (@interactive)
            return "" if (input.empty?)

            name, args = input.split(" ", 2)

            @wishes.sort.map do |aliaz, wish|
                if (aliaz == name)
                    begin
                        djinni_env["djinni_input"] = input
                        wish.execute(args, djinni_env)
                    rescue SystemExit => e
                        raise e
                    rescue Exception => e
                        puts e.message
                    end
                    store_history(input)
                    return ""
                end
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
        @wishes = Hash.new
        @history = Array.new
        @hist_index = nil
        @interactive = interactive
        @loaded_from = Array.new
        @width = TermInfo.screen_size[1]

        Signal.trap(
            "SIGWINCH",
            proc do
                @width = TermInfo.screen_size[1]
            end
        )

        load_wishes("#{File.dirname(__FILE__)}/djinni/wish")
    end

    def load_wishes(dir)
        return if @loaded_from.include?(dir)

        classes = Fagin.find_children("Djinni::Wish", dir)
        classes.each do |clas, wish|
            wish.aliases.each do |aliaz|
                @wishes[aliaz] = wish
            end
        end

        @loaded_from.push(dir)
    end

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
            buff = grant_wish(buff + input, djinni_env)

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
