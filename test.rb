require 'rif/rif'

include Rif::GlobalHelpers

loader = Rif::GameLoader.new
game   = loader.load_dir(File.dirname(__FILE__) + '/game')
runner = Rif::Runners::ConsoleRunner.new(game)

runner.run