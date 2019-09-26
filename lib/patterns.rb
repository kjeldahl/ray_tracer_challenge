require_relative 'patterns/pattern'
Dir[File.join File.dirname(__FILE__), "patterns", "*.rb"].sort.each { |f| require f }