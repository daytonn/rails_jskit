require "json"

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

namespace :jskit do
  desc "Update jskit with npm"
  task :update do
    js_dir = File.join(Rake.original_dir, "app", "assets", "javascripts")
    npm_jskit_dir = File.join(Rake.original_dir, "node_modules", "jskit", "dist")
    jskit_files = %w(jskit.js jskit.min.js)

    puts "Removing existing jskit files..."
    jskit_files.each do |file|
      full_path = File.join(js_dir, file)
      if File.exists? full_path
        puts "Removed #{file}." if FileUtils.rm(full_path)
      end
    end
    puts "JSKit files removed."

    puts "Installing JSKit from npm.."
    puts %x{npm install}

    package_file = File.join(Rake.original_dir, "node_modules", "jskit", "package.json")
    package_json = JSON.parse(File.read(package_file))
    puts "JSKit #{package_json['version']} installed from npm."

    puts "Copying JSKit to #{js_dir}..."
    jskit_files.each do |file|
      full_npm_path = File.join(npm_jskit_dir, file)
      full_js_path = File.join(js_dir, file)

      if File.exists? full_npm_path
        FileUtils.cp(full_npm_path, full_js_path)
        puts "Copied #{file}." if File.exists? full_js_path
      end
    end
  end
end
