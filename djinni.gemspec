Gem::Specification.new do |s|
    s.name = "djinni"
    s.version = "2.1.1"
    s.date = Time.new.strftime("%Y-%m-%d")
    s.summary = "A Ruby command handler"
    s.description =
        "This Ruby gem accepts user input and handles commands " \
        "(a.k.a. wishes). It dynamically loads user-defined " \
        "wishes, maintains a history, and provides tab completion."
    s.authors = [ "Miles Whittaker" ]
    s.email = "mjwhitta@gmail.com"
    s.files = Dir["lib/**/*.rb"]
    s.homepage = "https://mjwhitta.github.io/djinni"
    s.license = "GPL-3.0"
    s.add_development_dependency("minitest", "~> 5.8", ">= 5.8.4")
    s.add_development_dependency("rake", "~> 10.5", ">= 10.5.0")
    s.add_runtime_dependency("fagin", "~> 1.0", ">= 1.0.0")
end
