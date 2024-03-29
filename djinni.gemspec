Gem::Specification.new do |s|
    s.add_development_dependency("minitest", "~> 5.12", ">= 5.12.2")
    s.add_development_dependency("rake", "~> 13.0", ">= 13.0.0")
    s.add_runtime_dependency("fagin", "~> 1.2", ">= 1.2.2")
    s.authors = ["Miles Whittaker"]
    s.date = Time.new.strftime("%Y-%m-%d")
    s.description = [
        "This Ruby gem accepts user input and handles commands",
        "(a.k.a. wishes). It dynamically loads user-defined wishes,",
        "maintains a history, and provides rich-tab completion."
    ].join(" ")
    s.email = "mj@whitta.dev"
    s.files = Dir["lib/**/*.rb"]
    s.homepage = "https://github.com/mjwhitta/djinni"
    s.license = "GPL-3.0"
    s.metadata = {"source_code_uri" => s.homepage}
    s.name = "djinni"
    s.summary = "A Ruby command handler"
    s.version = "2.2.5"
end
