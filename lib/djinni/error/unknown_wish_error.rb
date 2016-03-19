class Djinni::Error::UnknownWishError < Djinni::Error
    def initialize(clas = "")
        super("Unknown wish class #{clas}!")
    end
end
