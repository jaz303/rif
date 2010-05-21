module Rif
  class Command
    attr_reader :game, :entity, :sentence, :messages
    
    def initialize(game, entity, sentence)
      @game     = game
      @entity   = entity
      @sentence = sentence
      @handled  = false
      @turn     = true
      @messages = []
    end
    
    def room
      entity.room
    end
    
    def vocab
      game.vocab
    end
    
    def handled?
      @handled
    end
    
    def handled!
      @handled = true
    end
    
    # if false, this command does not constitute a "turn"
    def turn?
      @turn
    end
    
    def no_turn!
      @turn = false
    end
    
    def info(msg)
      @messages << [:info, msg]
    end
    
    def error(msg)
      @messages << [:error, msg]
    end
    
    def success(msg)
      @messages << [:success, msg]
    end
  end
end