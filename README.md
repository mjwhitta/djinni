# Djinni

Your wish is my command

## What is this?

This Ruby gem accepts user input and handles commands (a.k.a. wishes).
It dynamically loads user-defined wishes, maintains a history, and
provides tab completion.

## Example project

```ruby
#!/usr/bin/env ruby

require "djinni"

djinni = Djinni.new
djinni.load_wishes("/path/to/wishes/dir")
djinni.prompt
```

## TODO

- [ ] Left/Right arrow keys
