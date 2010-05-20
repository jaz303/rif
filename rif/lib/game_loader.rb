module Rif
  class GameLoader
    
    def initialize
    end
    
    def load_dir(dir)
      game = Rif.new_game!
      
      require File.join(dir, 'game')
      require File.join(dir, 'vocab')
      require File.join(dir, 'rules')
      
      Dir[File.join(dir, 'rooms', '**/*.rb')].each do |f|
        require f
      end
      
      game.prepare
      game
    end
    
  end
end