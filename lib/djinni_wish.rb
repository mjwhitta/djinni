class DjinniWish
    class InterfaceNotImplementedError < NoMethodError
    end

    def aliases
        raise InterfaceNotImplementedError.new(
            "aliases() not implemented!"
        )
    end

    def description
        raise InterfaceNotImplementedError.new(
            "description() not implemented!"
        )
    end

    def execute(args, djinni_env = {})
        raise InterfaceNotImplementedError.new(
            "execute() not implemented!"
        )
    end

    def tab_complete(input, djinni_env = {})
        raise InterfaceNotImplementedError.new(
            "tab_complete() not implemented!"
        )
    end

    def usage
        raise InterfaceNotImplementedError.new(
            "usage() not implemented!"
        )
    end
end
