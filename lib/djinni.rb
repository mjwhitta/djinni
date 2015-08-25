require "io/console"
require "pathname"
require "terminfo"

require_relative "djinni_wish"

class Exit
    GOOD = 0
    UNKNOWN_WISH = 1
end

class Djinni
    def grant_wish(input)
        return "" if (input.nil? || input.empty?)

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
                return "#{name} #{wish.tab_complete(args)}"
            else
                wishes = @wishes.keys
                wishes.push("help")
                wishes.push("history")
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

            # Only keep newest wish if repeat
            @history.delete(input)
            @history.push(input)
            @hist_index = nil

            name, args = input.split(" ", 2)

            if ((name == "help") || (name == "?"))
                print_help
                return ""
            end

            if ((name == "history") || (name == "hist"))
                print_history
                return ""
            end

            @wishes.sort.map do |aliaz, wish|
                if (aliaz == name)
                    wish.execute(args)
                    return ""
                end
            end
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
                # TODO maybe
                return input[0..-2]
            when "\e[D" # Left arrow
                # TODO maybe
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
                next if (clas.nil?)
                clas.strip!
                next if (clas.empty?)

                wish = nil
                begin
                    wish = Object::const_get(clas).new
                rescue NameError => e
                    puts "Unknown wish class #{clas}!"
                    exit Exit::UNKNOWN_WISH
                end

                next if (wish.nil?)

                wish.aliases.each do |aliaz|
                    @wishes[aliaz] = wish
                end
            end
        end

        @loaded_from.push(dir)
    end

    def print_help
        @wishes.sort.map do |aliaz, wish|
            puts "#{aliaz}\t#{wish.description}"
        end
    end

    def print_history
        @history.each do |wish|
            puts wish
        end
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
end
