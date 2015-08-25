#!/usr/bin/env ruby

require "djinni"

djinni = Djinni.new
djinni.load_wishes("test/wishes")
djinni.prompt
