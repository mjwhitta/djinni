require "djinni"
require "minitest/autorun"

class DjinniTest < Minitest::Test
    @djinni = nil

    def setup
        @djinni = Djinni.new
        @djinni.load_wishes(Pathname.new("test/wishes").expand_path)
    end

    def test_backspace
        assert_equal(@djinni.grant_wish("foobarr\x7F"), "foobar")
    end

    def test_incomplete_wish
        assert_equal(@djinni.grant_wish("who"), "who")
    end

    def test_invalid_wish
        assert_nil(@djinni.grant_wish("foobar\n"))
    end

    def test_wish
        assert_empty(@djinni.grant_wish("id\r"))
        assert_empty(@djinni.grant_wish("whoami\n"))
        assert_empty(@djinni.grant_wish("me\n"))
    end
end
