begin
  require "bundler/setup"
rescue LoadError
  puts "You must `gem install bundler` and `bundle install` to run rake tasks"
end

Bundler::GemHelper.install_tasks

namespace :version do
  task :write do
    File.write(File.join(Rake.original_dir, "VERSION"), [ENV["MAJOR"], ENV["MINOR"], ENV["PATCH"]].join("."))
  end

  namespace :bump do
    major, minor, patch = JskitRails::VERSION.split(".").map(&:to_i)

    task :major do
      major += 1
      File.write(File.join(Rake.original_dir, "VERSION"), [major, minor, patch].join("."))
    end

    task :minor do
      minor += 1
      File.write(File.join(Rake.original_dir, "VERSION"), [major, minor, patch].join("."))
    end

    task :patch do
      patch += 1
      File.write(File.join(Rake.original_dir, "VERSION"), [major, minor, patch].join("."))
    end
  end
end
