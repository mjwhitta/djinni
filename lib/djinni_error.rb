module DjinniError
    class Error < RuntimeError
    end

    class UnknownWish < Error
        def initialize(clas = "")
            super("Unknown wish class #{clas}!")
        end
    end
end
