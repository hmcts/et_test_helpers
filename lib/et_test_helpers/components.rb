require_relative './capybara'
require 'site_prism'
Dir[File.absolute_path(File.join('.', 'components', '**', '*'), __dir__)].sort.each {|f| require f}
