require "json"

begin
  require "bundler/setup"
rescue LoadError
  puts "You must `gem install bundler` and `bundle install` to run rake tasks"
end

Bundler::GemHelper.install_tasks

def jskit_package_json_file
  File.join(Rake.original_dir, "node_modules", "jskit", "package.json")
end

def jskit_package_json
  JSON.parse File.read(jskit_package_json_file)
end

def package_json_file
  File.join(Rake.original_dir, "package.json")
end

def package_json
  JSON.parse(File.read(package_json_file))
end

namespace :version do
  def update_package_json(version)
    new_package_json = package_json.merge("version" => version)
    File.write(package_json_file, JSON.pretty_generate(new_package_json))
  end

  def update_version_file(version)
    File.write(File.join(Rake.original_dir, "VERSION"), version)
  end

  task :write do
    version = [ENV["MAJOR"] || 0, ENV["MINOR"] || 0, ENV["PATCH"] || 0].join(".")
    update_version_file(version)
    update_package_json(version)
    puts %Q(Version is set to: #{version})
  end

  namespace :bump do

    major, minor, patch = JskitRails::VERSION.split(".").map(&:to_i)

    task :major do
      version = [major + 1, 0, 0].join(".")
      update_version_file(version)
      update_package_json(version)
      puts %Q(Updated to version: #{version})
    end

    task :minor do
      version = [major, minor + 1, 0].join(".")
      update_version_file(version)
      update_package_json(version)
      puts %Q(Updated to version: #{version})
    end

    task :patch do
      version = [major, minor, patch + 1].join(".")
      update_version_file(version)
      update_package_json(version)
      puts %Q(Updated to version: #{version})
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
    puts %x{npm update jskit}
    puts "JSKit #{jskit_package_json['version']} installed from npm."

    puts "Copying JSKit to #{js_dir}..."
    Dir["#{npm_jskit_dir}/*"].each do |file|
      FileUtils.cp_r(file, js_dir)
    end
    FileUtils.rm_rf("#{js_dir}/jskit")
    FileUtils.mv("#{js_dir}/es6", "#{js_dir}/jskit")
    Dir["#{js_dir}/jskit/**/*.js"].each do |file|
      FileUtils.mv(file, "#{file}.es6")
    end
  end
end
