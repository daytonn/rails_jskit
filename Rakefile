begin
  require "bundler/setup"
rescue LoadError
  puts "You must `gem install bundler` and `bundle install` to run rake tasks"
end

Bundler::GemHelper.install_tasks

namespace :version do
  task :bump do
    File.write(File.join(Rake.original_dir, "VERSION"), [ENV["MAJOR"], ENV["MINOR"], ENV["PATCH"]].join("."))
  end
end
