require "djinni/error.rb"

class Djinni::UnknownWishError < Djinni::Error
    def initialize(clas = "")
        super("Unknown wish class #{clas}!")
    end
end
