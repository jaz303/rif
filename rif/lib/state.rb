module Rif
  class State
    attr_reader :turns
    attr_accessor :room
   
    def initialize(game)
      @game   = game
      @turns  = 0
      @room   = @game.rooms.values.find { |r| r.starting_room? }
    end
    
    def turn!
      @turns += 1
    end
  end
end