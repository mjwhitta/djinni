Gem::Specification.new do |s|
    s.name = "djinni"
    s.version = "0.1.9"
    s.date = Time.new.strftime("%Y-%m-%d")
    s.summary = "A Ruby command handler"
    s.description =
        "This Ruby gem accepts user input and handles commands " \
        "(a.k.a. wishes). It dynamically loads user-defined " \
        "wishes, maintains a history, and provides tab completion."
    s.authors = [ "Miles Whittaker" ]
    s.email = "mjwhitta@gmail.com"
    s.files = Dir["lib/*.rb"] + Dir["lib/builtin/*.rb"]
    s.homepage = "http://mjwhitta.github.io/djinni"
    s.license = "GPL-3.0"
    s.add_development_dependency("minitest", "~> 5.8", ">= 5.8.1")
    s.add_runtime_dependency("ruby-terminfo", "~> 0.1", ">= 0.1.1")
end
