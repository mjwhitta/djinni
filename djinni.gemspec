Gem::Specification.new do |s|
    s.name = "djinni"
    s.version = "2.2.5"
    s.date = Time.new.strftime("%Y-%m-%d")
    s.summary = "A Ruby command handler"
    s.description = [
        "This Ruby gem accepts user input and handles commands",
        "(a.k.a. wishes). It dynamically loads user-defined wishes,",
        "maintains a history, and provides rich-tab completion."
    ].join(" ")
    s.authors = ["Miles Whittaker"]
    s.email = "mj@whitta.dev"
    s.files = Dir["lib/**/*.rb"]
    s.homepage = "https://gitlab.com/mjwhitta/djinni"
    s.license = "GPL-3.0"
    s.add_development_dependency("minitest", "~> 5.12", ">= 5.12.2")
    s.add_development_dependency("rake", "~> 13.0", ">= 13.0.0")
    s.add_runtime_dependency("fagin", "~> 1.2", ">= 1.2.2")
end
