require_relative 'shapes/shape'
Dir[File.join File.dirname(__FILE__), "shapes", "*.rb"].sort.each { |f| require f }
Dir[File.join File.dirname(__FILE__), "shapes", "composite", "*.rb"].sort.each { |f| require f }