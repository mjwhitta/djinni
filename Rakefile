require "rake/testtask"

task :default => :gem

desc "Clean up"
task :clean do
    system("rm -f *.gem")
end

desc "Test example project"
task :ex => :install do
    system("bin/djinni_proj.rb")
end

desc "Build gem"
task :gem do
    system("chmod -R u=rwX,go=rX lib")
    system("gem build djinni*.gemspec")
end

desc "Build and install gem"
task :install => :gem do
    system("gem install djinni*.gem")
end

desc "Run tests"
Rake::TestTask.new do |t|
    t.libs << "test"
end

desc "List key codes"
task :whatkey do
    require "io/console"
    loop do
        char = STDIN.getch
        case char
        when "\x03" # ^C
            exit
        else
            puts char.dump
        end
    end
end
