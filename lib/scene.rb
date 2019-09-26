require_relative 'scene/world'
Dir[File.join File.dirname(__FILE__), "scene", "*.rb"].sort.each { |f| require f }