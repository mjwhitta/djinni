require "io/console"
require "pathname"
require "terminfo"

require_relative "djinni_exit"
require_relative "djinni_wish"

class Djinni
    def grant_wish(input, env = {})
        return "" if (input.nil? || input.empty?)

        env["djinni"] = self
        env["djinni_history"] = @history
        env["djinni_wishes"] = @wishes

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
                return "#{name} #{wish.tab_complete(args, env)}"
            else
                wishes = @wishes.keys
                wishes.sort.each do |wish|
                    if (wish.start_with?(input))
                        return wish
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
                    wish.execute(args, env)
                    store_history(input)
                    return ""
                end
            end
            store_history(input)
            return nil
        when "\e" # Arrow keys
            code = "\e"
            Thread.new do
                code += STDIN.getch + STDIN.getch
            end.join(0.001).kill

            case code
            when "\e[A" # Up arrow
                @hist_index = @history.size if (@hist_index.nil?)
                @hist_index = 1 if (@hist_index == 0)
                @hist_index -= 1
                return @history[@hist_index]
            when "\e[B" # Up arrow
                @hist_index = @history.size if (@hist_index.nil?)
                @hist_index += 1
                if (@hist_index < @history.size)
                    return @history[@hist_index]
                else
                    @hist_index = @history.size
                    return ""
                end
            when "\e[C" # Right arrow
                # TODO maybe implement right arrow
                return input[0..-2]
            when "\e[D" # Left arrow
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

        load_builtins
    end

    def load_builtins
        builtins = {
            "help": "DjinniHelpWish",
            "history": "DjinniHistoryWish",
            "quit": "DjinniQuitWish"
        }

        builtins.each do |file, wish|
            require_relative "builtin/#{file}"
            load_wish(wish)
        end
    end

    def load_wish(clas)
        return if (clas.nil?)
        clas.strip!
        return if (clas.empty?)

        wish = nil
        begin
            wish = Object::const_get(clas).new
        rescue NameError => e
            puts "Unknown wish class #{clas}!"
            exit DjinniExit::UNKNOWN_WISH
        end

        return if (wish.nil?)

        wish.aliases.each do |aliaz|
            @wishes[aliaz] = wish
        end
    end

    def load_wishes(dir)
        return if @loaded_from.include?(dir)

        path = Pathname.new(dir).expand_path

        # puts "Loading wishes from #{path}"
        Dir["#{path}/*.rb"].each do |file|
            # puts "Loading #{clas}"
            require_relative file

            %x(
                \grep -E "class .* \< DjinniWish" #{file} | \
                    awk '{print $2}'
            ).each_line do |clas|
                load_wish(clas)
            end
        end

        @loaded_from.push(dir)
    end

    def prompt(prompt_sym = "$ ")
        @interactive = true

        buffer = ""
        loop do
            blank_line = Array.new(@width, " ").join
            fill_len = @width - prompt_sym.length - buffer.length + 1

            # Handle long line-wrapped prompts
            lines = (prompt_sym.length + buffer.length) / @width
            lines.times do
                print "\r#{blank_line}"
                print "\e[F"
            end

            # Redisplay prompt
            print "\r#{blank_line}"
            print "\r#{prompt_sym}#{buffer}"

            # Process input
            buffer = grant_wish(buffer + STDIN.getch)

            if (buffer.nil?)
                puts "Wish not found!"
                buffer = ""
            end

            # Exit on ^D
            if (buffer == "\x04")
                return
            end
        end
    end

    def store_history(input)
        # Only keep newest wish if repeat
        # @history.delete(input)

        @history.push(input)
        @hist_index = nil
    end
end
