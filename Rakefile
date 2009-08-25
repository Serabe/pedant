require 'rake/testtask'

desc "Default Task"
task :default => [:tests]

desc "Run All Tests"
Rake::TestTask.new :tests do |test|
  test.test_files = ["test/*.rb"]
  test.verbose = true
  test.warning = true
end

