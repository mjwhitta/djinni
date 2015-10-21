require "djinni/error.rb"

class Djinni::Error::UnknownWishError < Djinni::Error
    def initialize(clas = "")
        super("Unknown wish class #{clas}!")
    end
end
