class Djinni::Error::UnknownWish < Djinni::Error
    def initialize(clas = "")
        super("Unknown wish class #{clas}!")
    end
end
