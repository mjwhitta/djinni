Gem::Specification.new do |s|
    s.name = "djinni"
    s.version = "0.1.1"
    s.date = "2015-08-24"
    s.summary = "A Ruby command handler"
    s.description =
        "This Ruby gem accepts user input and handles commands " \
        "(a.k.a. wishes). It dynamically loads user-defined " \
        "wishes, maintains a history, and provides tab completion."
    s.authors = [ "Miles Whittaker" ]
    s.email = "mjwhitta@gmail.com"
    s.files = Dir["lib/*.rb"]
    s.homepage = "http://mjwhitta.github.io/djinni"
    s.license = "GPL-3.0"
end
