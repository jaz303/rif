module Rif
  class Commands
    
    def initialize(game, state)
      @game = game
      @state = state
    end
    
    def turns
      "You have taken #{@state.turns} turns"
    end
    
    def describe
      @state.room.description
    end
    
    def method_missing(method, *args, &block)
      "I can't do that"
    end
    
    %w(
      north
      northeast
      east
      southeast
      south
      southwest
      west
      northwest
    ).each do |direction|
      direction = direction.to_sym
      define_method(direction) do
        direction = direction.to_s
        if @state.room.exits.key?(direction)
          @state.room = @game.rooms[Room.sanitise_id(@state.room.exits[direction])]
          @state.turn!
          describe
        else
          "I can't go that way"
        end
      end
    end
    
    alias :n :north
    alias :s :south
    alias :se :southeast
    alias :sw :southwest
    alias :e :east
    alias :w :west
    alias :ne :northeast
    alias :nw :northwest
    
  end
end