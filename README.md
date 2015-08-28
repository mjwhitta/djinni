# Djinni

Your wish is my command

## What is this?

This Ruby gem accepts user input and handles commands (a.k.a. wishes).
It dynamically loads user-defined wishes, maintains a history, and
provides tab completion.

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
    buffer = djinni.grant_wish(buffer + STDIN.getch)
    # Display new buffer
end
```

## Links

- [Homepage](http://mjwhitta.github.io/djinni)
- [Source](https://gitlab.com/mjwhitta/djinni)
- [Mirror](https://github.com/mjwhitta/djinni)
- [RubyGems](https://rubygems.org/gems/djinni)

## TODO

- [ ] Left/Right arrow keys
- [ ] RDoc
