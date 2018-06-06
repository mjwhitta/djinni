# Djinni

Your wish is my command

## What is this?

This Ruby gem accepts user input and handles commands (a.k.a. wishes).
It dynamically loads user-defined wishes, maintains a history, and
provides tab completion.

## How to install

```
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

        # This function should do something like this:
        # completions = Hash.new
        # replace = "string to replace"
        # append = "string to append"
        # return [completions, replace, append]

        # Default behavior:
        # return [{}, "", ""]

        included = input.split(" ")
        last = included.delete_at(-1) if (!input.end_with?(" "))
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

        if (last)
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
```

The `tab_complete` method is optional. If you choose not to implement
it, the provided input will not be altered.

## Links

- [Source](https://gitlab.com/mjwhitta/djinni)
- [RubyGems](https://rubygems.org/gems/djinni)

## TODO

- Implement modes and mode switching
- Left/Right arrow keys
- RDoc
