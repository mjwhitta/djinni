Gem::Specification.new do |s|
    s.name = "djinni"
    s.version = "2.2.4"
    s.date = Time.new.strftime("%Y-%m-%d")
    s.summary = "A Ruby command handler"
    s.description =
        "This Ruby gem accepts user input and handles commands " \
        "(a.k.a. wishes). It dynamically loads user-defined " \
        "wishes, maintains a history, and provides tab completion."
    s.authors = [ "Miles Whittaker" ]
    s.email = "mjwhitta@gmail.com"
    s.files = Dir["lib/**/*.rb"]
    s.homepage = "https://gitlab.com/mjwhitta/djinni"
    s.license = "GPL-3.0"
    s.add_development_dependency("minitest", "~> 5.11", ">= 5.11.3")
    s.add_development_dependency("rake", "~> 12.3", ">= 12.3.0")
    s.add_runtime_dependency("fagin", "~> 1.2", ">= 1.2.1")
end
