# Djinni

Your wish is my command

## What is this?

This Ruby gem accepts user input and handles commands (a.k.a. wishes).
It dynamically loads user-defined wishes, maintains a history, and
provides tab completion.

## How to install

```bash
$ gem install djinni
```

## Example project

### Simple

```ruby
#!/usr/bin/env ruby

require "djinni"

djinni = Djinni.new
djinni.load_wishes("/path/to/wishes/dir")
djinni.prompt
```

### Advanced

```ruby
#!/usr/bin/env ruby

require "djinni"
require "io/console"

djinni = Djinni.new
djinni.load_wishes("/path/to/wishes/dir")

# Implement custom prompt below
# Can be used with curses or whatever you want
buffer = ""
loop do
    # Display buffer

    # Get new buffer
    buffer = djinni.grant_wish(buffer + STDIN.getch)
end
```

## Creating your own wishes

You can create you own wishes by extending `Djinni::Wish` like below:

```ruby
require "djinni"

class ListWish < Djinni::Wish
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
```

The `tab_complete` method is optional. If you choose not to implement
it, the provided input will be returned as is.

## Links

- [Homepage](https://mjwhitta.github.io/djinni)
- [Source](https://gitlab.com/mjwhitta/djinni)
- [Mirror](https://github.com/mjwhitta/djinni)
- [RubyGems](https://rubygems.org/gems/djinni)

## TODO

- Left/Right arrow keys
- RDoc
