module Rif
  module GlobalHelpers
    def game
      Rif.active_game
    end
    
    def zone(name)
      game.map.zone(name) { yield }
    end
    
    def room(name)
      game.map.room(name) { |r| yield r }
    end
    
    def vocab(&block)
      if block.arity > 0
        yield game.vocab
      else
        game.vocab.instance_eval(&block)
      end
    end
    
    def rewrite(from, to)
      # no-op
    end
    
    def rule(pattern, &block)
      game.rulebook.rule(pattern, &block)
    end
  end
end