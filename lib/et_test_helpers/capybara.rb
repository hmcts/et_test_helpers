require 'capybara'
require 'capybara/dsl'
Dir[File.absolute_path(File.join('.', 'capybara', '**', '*'), __dir__)].sort.each { |f| require f }
